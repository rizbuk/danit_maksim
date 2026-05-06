while True:


#    print("helo me")
#    print ( "a" )
#    def aaa(num1, num2):
#        print(num1)
#        print(num2)
#    aaa(111, 123)    


    def add(num1, num2):
        return num1 + num2


    def min(num1, num2):
        return num1 - num2

    def pom(num1, num2):
        return num1 * num2

    def pod(num1, num2):
        return num1 / num2

    a = float(input("enter 1 :"))
    b = float(input("enter 2 :"))
    op = input("enter operation :")

    if op == "+":
        res = add(a, b)
        print(res)
    elif op == "-":
        res = min(a, b)
        print(res)