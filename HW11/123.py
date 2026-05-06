import string

class Alphabet:
    def __init__(self, lang, letters):
        self.lang = lang
        self.letters = list(letters)

    def print(self):
        print(f"Літери алфавіту ({self.lang}): {self.letters}")

    def letters_num(self):
        return len(self.letters)

class EngAlphabet(Alphabet):
    __letters_num = 26  # Приватний статичний атрибут

    def __init__(self):
        # Викликаємо батьківський init, передаючи мову та всі англійські літери
        super().__init__('En', string.ascii_uppercase)

    def is_en_letter(self, letter):
        return letter.upper() in self.letters

    def letters_num(self):
        return EngAlphabet.__letters_num

    @staticmethod
    def example():
        return "The quick brown fox jumps over the lazy dog."

# Тести (main)
if __name__ == "__main__":
    # 1. Створення об’єкта
    eng_alp = EngAlphabet()

    # 2. Виведення літер алфавіту
    eng_alp.print()

    # 3. Виведення кількості літер
    print(f"Кількість літер: {eng_alp.letters_num()}")

    # 4. Перевірка літери 'F'
    print(f"Чи належить 'F' до алфавіту? {eng_alp.is_en_letter('F')}")

    # 5. Перевірка літери 'Щ'
    print(f"Чи належить 'Щ' до алфавіту? {eng_alp.is_en_letter('Щ')}")

    # 6. Виведення прикладу тексту
    print(f"Приклад тексту: {EngAlphabet.example()}")
