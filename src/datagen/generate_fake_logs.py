import random
import time
from datetime import datetime, timedelta

IP_PREFIXES = ["192.168", "10.0", "172.16", "203.0"]
HTTP_METHODS = ["GET", "POST", "PUT", "DELETE"]
ENDPOINTS = ["/home", "/login", "/api/data", "/images/logo.png", "/dashboard"]
STATUS_CODES = [200, 200, 200, 201, 404, 500, 301]
USER_AGENTS = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)",
    "Googlebot/2.1 (+http://www.google.com/bot.html)"
]

def generate_log_line():
    ip = f"{random.choice(IP_PREFIXES)}.{random.randint(0,255)}.{random.randint(1,255)}"
    timestamp = datetime.now().strftime("%d/%b/%Y:%H:%M:%S +0000")
    method = random.choice(HTTP_METHODS)
    endpoint = random.choice(ENDPOINTS)
    status = random.choice(STATUS_CODES)
    size = random.randint(100, 5000)
    ua = random.choice(USER_AGENTS)

    # Formato Padrão Apache Access Log
    return f'{ip} - - [{timestamp}] "{method} {endpoint} HTTP/1.1" {status} {size} "-" "{ua}"'

if __name__ == "__main__":
    filename = "sample_access_log.txt"
    print(f">>> Testando logs em {filename}")

    with open(filename, "w") as f:
        for _ in range(100):
            f.write(generate_log_line() + "\n")

    print("Concluído!")