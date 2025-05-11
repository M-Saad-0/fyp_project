import os
from flask import Flask, request, jsonify
from dotenv import load_dotenv, find_dotenv

from langchain_core.prompts import PromptTemplate
from langchain.chains import RetrievalQA
from langchain_community.vectorstores import FAISS
from langchain_groq import ChatGroq  # ✅ NEW for Groq
from langchain_huggingface import HuggingFaceEmbeddings

# Initialize Flask
app = Flask(__name__)

# Load environment variables
load_dotenv(find_dotenv())

# Step 1: Setup LLM (Groq with LangChain)
GROQ_API_KEY = os.environ.get("GROQ_API_KEY")
GROQ_MODEL_NAME = "llama3-70b-8192"

# Check API key
if not GROQ_API_KEY:
    raise ValueError("Groq API key (GROQ_API_KEY) not found in environment variables.")

def load_llm(model_name):
    return ChatGroq(
        api_key=GROQ_API_KEY,
        model_name=model_name,
        temperature=0.5,
        max_tokens=512,
    )

# Step 2: Custom Prompt Template
CUSTOM_PROMPT_TEMPLATE = """
Use the pieces of information provided in the context to answer the user's question.
If you don’t know the answer, just say that you don’t know. Don’t try to make up an answer.
Do not provide anything outside of the given context.

Context: {context}
Question: {question}

Start the answer directly. No small talk.
"""

def set_custom_prompt(custom_prompt_template):
    return PromptTemplate(template=custom_prompt_template, input_variables=["context", "question"])

# Step 3: Load FAISS Vector Store
DB_FAISS_PATH = "vectorstore/db_faiss"

if not os.path.exists(DB_FAISS_PATH):
    raise FileNotFoundError(f"FAISS database not found at {DB_FAISS_PATH}")

embedding_model = HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2")
db = FAISS.load_local(DB_FAISS_PATH, embedding_model, allow_dangerous_deserialization=True)

# Step 4: Create QA Chain
qa_chain = RetrievalQA.from_chain_type(
    llm=load_llm(GROQ_MODEL_NAME),
    chain_type="stuff",
    retriever=db.as_retriever(search_kwargs={'k': 3}),
    return_source_documents=True,
    chain_type_kwargs={'prompt': set_custom_prompt(CUSTOM_PROMPT_TEMPLATE)}
)

# API Route
@app.route('/ask', methods=['GET'])
def ask_question():
    user_query = request.args.get('query')
    
    if not user_query:
        return jsonify({"error": "Please provide a 'query' parameter."}), 400

    try:
        response = qa_chain.invoke({'query': user_query})
        result = response.get("result", "No answer found.")

        # Prepare source documents (optional: you can customize this)
        source_docs = []
        for doc in response.get("source_documents", []):
            source_docs.append({
                "content": doc.page_content,
                "metadata": doc.metadata
            })

        return jsonify({
            "query": user_query,
            "result": result,
            "source_documents": source_docs
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# # Run the app
# if __name__ == '__main__':
#     app.run(debug=True)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
