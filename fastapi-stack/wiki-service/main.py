from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from db import SessionLocal, engine
from models import User, Post, Base
from prometheus_client import Counter, generate_latest
from fastapi.responses import Response

Base.metadata.create_all(bind=engine)

app = FastAPI()

users_created = Counter("users_created_total", "Total users created")
posts_created = Counter("posts_created_total", "Total posts created")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.post("/users/")
def create_user(name: str, db: Session = Depends(get_db)):
    user = User(name=name)
    db.add(user)
    db.commit()
    users_created.inc()
    return {"message": "User created"}

@app.post("/posts/")
def create_post(title: str, db: Session = Depends(get_db)):
    post = Post(title=title)
    db.add(post)
    db.commit()
    posts_created.inc()
    return {"message": "Post created"}

@app.get("/metrics")
def metrics():
    return Response(generate_latest(), media_type="text/plain")
