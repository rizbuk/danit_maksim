 #!/bin/bash

echo "Введите предложение:"
read -r sentence

# Записываем слова в массив
words=($sentence)

# Выводим слова в обратном порядке
for (( i=${#words[@]}-1; i>=0; i-- )); do
    echo -n "${words[i]} "
done

echo "" # Перенос строки для красоты
