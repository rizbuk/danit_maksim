[Unit]
Description=Python Service for My App
After=network.target

[Service]
# Користувач, від якого запускається скрипт
User=root
# Шлях до папки з проектом
WorkingDirectory=/home/ubuntu/py/venv/
# Повний шлях до Python (краще використовувати Virtualenv) та скрипту
ExecStart=/home/ubuntu/py/venv/bin/python /home/ubuntu/py/venv/main.py
# Автоматичний перезапуск при краху
Restart=always
# Затримка перед перезапуском
RestartSec=5

[Install]
WantedBy=multi-user.target
