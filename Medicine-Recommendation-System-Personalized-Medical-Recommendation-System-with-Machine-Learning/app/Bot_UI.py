import os
import streamlit as st
from dotenv import load_dotenv, find_dotenv
from langchain_community.embeddings import HuggingFaceEmbeddings
from langchain_community.vectorstores import FAISS
from langchain.chains import RetrievalQA
from langchain.prompts import PromptTemplate
from langchain_groq import ChatGroq

# Load environment variables
load_dotenv(find_dotenv())

# Constants
DB_FAISS_PATH = "vectorstore/db_faiss"
GROQ_API_KEY = os.getenv("GROQ_API_KEY")
GROQ_MODEL_NAME = "llama3-70b-8192"

# Ensure API key is available
if not GROQ_API_KEY:
    st.error("GROQ API key not found in environment variables.")
    st.stop()

@st.cache_resource
def get_vectorstore():
    try:
        embedding_model = HuggingFaceEmbeddings(model_name='sentence-transformers/all-MiniLM-L6-v2')
        db = FAISS.load_local(DB_FAISS_PATH, embedding_model, allow_dangerous_deserialization=True)
        return db
    except Exception as e:
        st.error(f"Failed to load vector store: {str(e)}")
        return None

def set_custom_prompt():
    custom_prompt_template = """
    Use the pieces of information provided in the context to answer the user's question.
    If the answer is not available in the context, use your own knowledge to answer,
    but strictly limit your answer to the medical field only.

    Do not provide answers outside the medical field.

    Context: {context}
    Question: {question}

    Start the answer directly. No small talk please.
    """

    return PromptTemplate(template=custom_prompt_template, input_variables=["context", "question"])

def load_llm():
    try:
        return ChatGroq(
            api_key=GROQ_API_KEY,
            model_name=GROQ_MODEL_NAME,
            temperature=0.3
        )
    except Exception as e:
        st.error(f"Failed to load Groq LLM: {str(e)}")
        return None

def main():
    st.title("🧠 Medical Chatbot")

    if 'messages' not in st.session_state:
        st.session_state.messages = []

    for message in st.session_state.messages:
        st.chat_message(message['role']).markdown(message['content'])

    if prompt := st.chat_input("Ask me a medical question..."):
        st.chat_message("user").markdown(prompt)
        st.session_state.messages.append({"role": "user", "content": prompt})

        try:
            vectorstore = get_vectorstore()
            if vectorstore is None:
                return

            llm = load_llm()
            if llm is None:
                return

            qa_chain = RetrievalQA.from_chain_type(
                llm=llm,
                chain_type="stuff",
                retriever=vectorstore.as_retriever(search_kwargs={"k": 3}),
                return_source_documents=True,
                chain_type_kwargs={"prompt": set_custom_prompt()}
            )

            response = qa_chain.invoke({"query": prompt})
            result = response.get("result", "No answer found.")
            source_documents = response.get("source_documents", [])

            final_response = f"{result}\n\n**Sources:**\n"
            for doc in source_documents:
                source = doc.metadata.get("source", "Unknown source")
                page = doc.metadata.get("page", "N/A")
                final_response += f"- {source} (page {page})\n"

            st.chat_message("assistant").markdown(final_response)
            st.session_state.messages.append({"role": "assistant", "content": final_response})

        except Exception as e:
            st.error(f"Error: {str(e)}")

if __name__ == "__main__":
    main()
