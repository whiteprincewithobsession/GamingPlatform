from pydantic import EmailStr

class User():
    UserID: int
    Username: str
    UserPassword: str
    Email: EmailStr
    RegistrationdDate: str
    CashBalance: float
    
   