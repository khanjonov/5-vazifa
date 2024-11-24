import psycopg2
from datetime import date

conn = psycopg2.connect(
    dbname="your_database",
    user="your_user",
    password="your_password",
    host="localhost",
    port="5432"
)

cursor = conn.cursor()

def create_tables():
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS avtomobillar (
            id SERIAL PRIMARY KEY,
            nomi VARCHAR(100) NOT NULL,
            model TEXT,
            yil INTEGER,
            narx NUMERIC(12, 2),
            mavjudmi BOOL DEFAULT TRUE
        );
    """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS clientlar (
            id SERIAL PRIMARY KEY,
            ism VARCHAR(50) NOT NULL,
            familiya VARCHAR(50),
            telefon CHAR(13),
            manzil TEXT
        );
    """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS buyurtmalar (
            id SERIAL PRIMARY KEY,
            avtomobil_id INTEGER REFERENCES avtomobillar(id),
            client_id INTEGER REFERENCES clientlar(id),
            sana DATE NOT NULL,
            umumiy_narx NUMERIC(12, 2)
        );
    """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS xodimlar (
            id SERIAL PRIMARY KEY,
            ism VARCHAR(50) NOT NULL,
            lavozim VARCHAR(50),
            maosh NUMERIC(10, 2)
        );
    """)

    conn.commit()
    print("Jadvallar yaratildi!")

def modify_tables():
    cursor.execute("ALTER TABLE clientlar ADD COLUMN IF NOT EXISTS email VARCHAR(100);")
    cursor.execute("ALTER TABLE clientlar RENAME COLUMN ism TO ism_sharif;")
    cursor.execute("ALTER TABLE clientlar RENAME TO mijozlar;")

    conn.commit()
    print("Jadvalga ozgartirishlar kiritildi!")

def insert_data():
    cursor.execute("""
        INSERT INTO avtomobillar (nomi, model, yil, narx, mavjudmi)
        VALUES ('Chevrolet', 'Malibu', 2020, 25000.00, TRUE),
               ('Toyota', 'Camry', 2021, 30000.00, TRUE);
    """)

    cursor.execute("""
        INSERT INTO mijozlar (ism_sharif, familiya, telefon, manzil, email)
        VALUES ('Ali', 'Valiyev', '+998901234567', 'Toshkent', 'ali@gmail.com'),
               ('Aziza', 'Karimova', '+998901234568', 'Samarqand', 'aziza@gmail.com');
    """)

    cursor.execute("""
        INSERT INTO buyurtmalar (avtomobil_id, client_id, sana, umumiy_narx)
        VALUES (1, 1, %s, 25000.00),
               (2, 2, %s, 30000.00);
    """, (date(2024, 11, 1), date(2024, 11, 15)))

    cursor.execute("""
        INSERT INTO xodimlar (ism, lavozim, maosh)
        VALUES ('Jasur', 'Menejer', 1200.50),
               ('Madina', 'Sotuvchi', 800.00);
    """)

    conn.commit()
    print("Malumotlar kiritildi!")

def update_data():
    cursor.execute("UPDATE xodimlar SET ism = 'Olim' WHERE id = 1;")
    cursor.execute("UPDATE xodimlar SET ism = 'Shahlo' WHERE id = 2;")

    conn.commit()
    print("Malumotlar ozgartirildi!")

def delete_data():
    cursor.execute("DELETE FROM xodimlar WHERE id = 1;")

    conn.commit()
    print("Malumotlar ochirildi!")

def fetch_data():
    tables = ['avtomobillar', 'mijozlar', 'buyurtmalar', 'xodimlar']
    for table in tables:
        cursor.execute(f"SELECT * FROM {table};")
        rows = cursor.fetchall()
        print(f"\n{table} jadvalidagi ma'lumotlar:")
        for row in rows:
            print(row)

create_tables()
modify_tables()
insert_data()
update_data()
delete_data()
fetch_data()

cursor.close()
conn.close()
