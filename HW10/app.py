import requests
resp = requests.get("https://jsonplaceholder.typicode.com/users")
#print(resp.json())
users = resp.json()
for item in users:
    lat = item["address"]["geo"]["lat"]
    lng = item["address"]["geo"]["lng"]

    kar =  requests.get(f"https://geocode.maps.co/reverse?lat={lat}&lon={lng}&api_key=69fb13dbb1590198246276wkb54354b")

    print (kar.text)

#clehttps://geocode.maps.co/reverse?lat=40.7558017&lon=-73.9787414&api_key=YOUR_SECRET_API_KEY


# resp1 = requests.get("https://jsonplaceholder.typicode.com/posts")
# posts = resp1.json()
# for item in posts:
#     if item["userId"] == 1:
#         print(item)
        
# def gup(userid):
#     cou = 0
#     resp1 = requests.get("https://jsonplaceholder.typicode.com/posts")
#     posts = resp1.json()
#     for item in posts:
#         if item["userId"] == userid:
#             cou = cou + 1
#             print(item)
#     print(cou)
# gup(userid=2)

