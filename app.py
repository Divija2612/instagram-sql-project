import streamlit as st
import pandas as pd
import plotly.express as px
from db import get_engine

st.set_page_config(page_title="Instagram Dashboard", layout="wide")

st.title("Instagram Dashboard")

engine = get_engine()

# USERS TABLE
users_df = pd.read_sql("SELECT * FROM users;", engine)
st.subheader("Users Table")
st.dataframe(users_df)

# LIKES PER POST
likes_df = pd.read_sql("""
SELECT p.caption, COUNT(l.like_id) AS likes
FROM posts p
LEFT JOIN likes l ON p.post_id = l.post_id
GROUP BY p.caption
""", engine)

st.subheader("Likes per Post")
st.dataframe(likes_df)

fig = px.bar(
    likes_df,
    x="caption",
    y="likes",
    title="Likes per Post"
)

st.plotly_chart(fig, use_container_width=True)
# COMMENTS PER POST
comments_df = pd.read_sql("""
SELECT p.caption, COUNT(c.comment_id) AS comments
FROM posts p
LEFT JOIN comments c ON p.post_id = c.post_id
GROUP BY p.caption
""", engine)

st.subheader("Comments per Post")
st.dataframe(comments_df)

fig2 = px.bar(
    comments_df,
    x="caption",
    y="comments",
    title="Comments per Post"
)

st.plotly_chart(fig2, use_container_width=True) 