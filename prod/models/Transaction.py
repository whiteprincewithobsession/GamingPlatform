from datetime import datetime

class Transaction():
    TransactionID: int
    TransactionCode: str
    UserID: int
    GameID: int
    Amount: int
    TrType: int
    TransactionTime: datetime