# exclosured.app + 6 subdomains -> backend ports 5000–5015 on peko.
# CF tunnel terminates TLS at the edge; we serve both HTTP (80) and HTTPS (443)
# so cloudflared can use either as the origin without reconfiguration.

map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

# === Apex: exclosured.app -> :5000 (landing) ===
server {
    listen 80;
    listen [::]:80;
    listen 443 ssl;
    listen [::]:443 ssl;
    http2 on;
    server_name exclosured.app;

    ssl_certificate /etc/letsencrypt/live/exclosured.app/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/exclosured.app/privkey.pem;
    client_max_body_size 512m;

    location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $http_host;

        proxy_pass http://127.0.0.1:5000;
        proxy_redirect off;

        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
    }
}

# === Subdomains: <name>.exclosured.app -> backend port ===
# Single map keeps the config compact; backend ports are 5xxx.
map $host $exclosured_backend {
    default                                    "";
    latency-compare.exclosured.app             5007;
    private-analytics.exclosured.app           5011;
    live-vue-wasm.exclosured.app               5012;
    live-svelte-wasm.exclosured.app            5013;
    brotli-compress.exclosured.app             5014;
    matrix-mul.exclosured.app                  5015;
}

server {
    listen 80;
    listen [::]:80;
    listen 443 ssl;
    listen [::]:443 ssl;
    http2 on;
    server_name *.exclosured.app;

    ssl_certificate /etc/letsencrypt/live/exclosured.app/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/exclosured.app/privkey.pem;
    client_max_body_size 512m;

    # Hostnames not in the map fall through to 404 — keeps room for the other 9
    # local-only demos to be added later by extending the map.
    if ($exclosured_backend = "") {
        return 404;
    }

    location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $http_host;

        proxy_pass http://127.0.0.1:$exclosured_backend;
        proxy_redirect off;

        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
    }
}
