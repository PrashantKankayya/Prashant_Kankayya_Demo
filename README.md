
# Prashant Kankayya Demo Task

The Portfolio Manager app is a user-friendly solution designed to simplify stock investment management. It allows users to effortlessly track their stock holdings, monitor individual stock performance using a Pull to Refresh feature, and calculate the overall profit or loss of their portfolio. Additionally, it incorporates dynamic animations to visually represent money, making the experience more engaging and intuitive.

Key Features:
1. Manage Stock Holdings
The Portfolio Manager helps users keep track of their investments by storing essential details for each stock in their portfolio:

Stock Name: The stock ticker or name (e.g., "AAPL", "GOOG").
Quantity: The number of shares owned.
Purchase Price: The price per share at the time of purchase (cost basis).
Current Price: The latest market price per share.

2. Calculate Individual Stock Performance
The system computes the profit or loss for each stock using the following formula:

Profit or Loss = (Current Price − Purchase Price) × Quantity

Profit: Occurs when the current price exceeds the purchase price.
Loss: Occurs when the current price is below the purchase price.

3. Calculate Total Portfolio Performance
The application calculates the overall profit or loss for the entire portfolio by summing up the profit or loss values of all individual stocks.

4. Intuitive Display of Results
The Portfolio Manager provides a clear and comprehensive view of the portfolio, including:

A detailed list of each stock, showing its name, quantity, purchase price, current price, and the profit or loss for that stock.
The total profit or loss for the entire portfolio, giving users a holistic view of their investment performance.

5. Pull To Refresh
Under Portfolio Tab, Holding Section you can try out pull to refresh feature, which will call api and get the latest updated data.
