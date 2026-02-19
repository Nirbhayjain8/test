from fastapi import FastAPI
from prometheus_client import Counter, generate_latest
from fastapi.responses import Response
import psycopg2
import os

app = FastAPI()

users_created = Counter("users_created_total", "Total users created")
posts_created = Counter("posts_created_total", "Total posts created")

DB_HOST = os.getenv("DB_HOST", "postgres")

def get_conn():
    return psycopg2.connect(
        host=DB_HOST,
        database="wiki",
        user="wiki",
        password="wiki"
    )

@app.get("/users/{id}")
def create_user(id: int):
    users_created.inc()
    return {"user_id": id}

@app.get("/posts/{id}")
def create_post(id: int):
    posts_created.inc()
    return {"post_id": id}

@app.get("/metrics")
def metrics():
    return Response(generate_latest(), media_type="text/plain")
