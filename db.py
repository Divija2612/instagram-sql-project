from sqlalchemy import create_engine

DB_USER = "postgres"
DB_PASSWORD = "hello2612"
DB_HOST = "localhost"
DB_PORT = "5432"
DB_NAME = "instagram"

engine = create_engine(
    f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

def get_engine():
    return engine
