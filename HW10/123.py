import random

def guess_the_number():
    target_number = random.randint(1, 100)
    attempts = 5

    print("Я загадав число від 1 до 100. У тебе є 5 спроб, щоб його відгадати.")

    for i in range(1, attempts + 1):
        try:
            guess = int(input(f"Спроба {i}: Введи своє число: "))
        except ValueError:
            print("Будь ласка, вводь тільки цілі числа.")
            continue

        if guess == target_number:
            print("Congratulations! You guessed the right number.")
            return
        elif guess < target_number:
            print("Too low")
        else:
            print("Too high")

    print(f"Sorry, you've run out of attempts. The correct number was {target_number}")

if __name__ == "__main__":
    guess_the_number()