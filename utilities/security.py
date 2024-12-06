import hashlib

def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

#pw = "aboba2281337"
#hash_pw = hash_password(pw)
