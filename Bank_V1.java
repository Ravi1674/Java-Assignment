// Bank POC version 1 Task...........

import java.util.*;

class User {
    private String name;
    private String city;
    private String contactNumber;
    private String username;
    private String password;
    private long initialDeposit;
    private long balance;
    private Queue<String> transactions;

    User(String name, String city, String contactNumber, String username, String password, long initialDeposit) {
        this.name = name;
        this.city = city;
        this.contactNumber = contactNumber;
        this.username = username;
        this.password = password;
        this.initialDeposit = initialDeposit;
        this.balance = initialDeposit;
        this.transactions = new LinkedList<>();
        if (initialDeposit > 0) {
            transactions.add("Initial deposited amount: " + this.initialDeposit);
        }
    }

    public String getName() {
        return this.name;
    }

    public String getCity() {
        return this.city;
    }

    public String getContactNumber() {
        return this.contactNumber;
    }

    public String getUsername() {
        return this.username;
    }

    public String getPassword() {
        return this.password;
    }

    public long getInitialDeposit() {
        return this.initialDeposit;
    }

    public long getBalance() {
        return this.balance;
    }

    public Queue<String> getTransactions() {
        return transactions;
    }

    public void addAmount(long amount) {
        this.balance += amount;
    }

    public void subAmount(long amount) {
        this.balance -= amount;
    }

    public void addTransaction(long amount, String type) {

        if (transactions.size() == 5) {
            transactions.poll();
        }

        if (type.equals("credit")) {
            transactions.add("Credited: " + amount);
        } else {
            transactions.add("Debited: " + amount);
        }

    }

    @Override
    public String toString() {
        return "Name: " + this.name + "\nCity: " + this.city + "\nUsername: " + this.username + "\nBalance: "
                + this.balance;
    }

}

class Bank {
    Scanner sc = new Scanner(System.in);

    private List<User> users = new ArrayList<User>();

    public void HomeMenu() {
        System.out.println("\n\n-----------------------");
        System.out.println("BANK    OF      MYBANK");
        System.out.println("-----------------------\n\n");

        System.out.println("1. Registration");
        System.out.println("2. Login");
        System.out.println("3. Exit\n");

        System.out.print("Enter your choice: ");
        int choice = sc.nextInt();

        switch (choice) {
            case 1:
                registerAccount();
                break;
            case 2:
                login();
                break;
            case 3:
                System.out.println("Thank You for Banking With Us!!");
                break;
            default:
                System.out.println("Enter Correct Choice.");
                HomeMenu();
        }
    }

    private void registerAccount() {
        sc.nextLine();

        System.out.print("Enter name: ");
        String name = sc.nextLine();

        System.out.print("Enter Address: ");
        String city = sc.nextLine();

        System.out.print("Enter Contact Number: ");
        String contactNumber = sc.nextLine();

        System.out.print("Set Username: ");
        String username = sc.nextLine();

        int incorrectPasswordCount = 0;
        String password;
        do {
            if (incorrectPasswordCount == 0)
                System.out.print(
                        "Set Password (minimum 8 characters; minimum 1 digit, 1 lowercase, 1 uppercase, 1 special character[!@#$%^&*_]): ");
            else
                System.out.print("Password doesn't match criteria. Set Again: ");

            ++incorrectPasswordCount;
            password = sc.nextLine();
        } while (incorrectPasswordCount != 1);

        System.out.print("Enter initial deposit: ");
        long initialDeposit = sc.nextLong();

        User newUser = new User(name, city, contactNumber, username, password, initialDeposit);
        users.add(newUser);

        HomeMenu();
    }

    public void login() {

        sc.nextLine();

        String username = "";
        System.out.println("Enter UserName : ");
        username = sc.nextLine();

        String password = "";
        System.out.println("Enter Password : ");
        password = sc.nextLine();

        boolean found = false;

        User foundUser = null;

        for (User user : users) {
            if (user.getUsername().equals(username) && user.getPassword().equals(password)) {
                // System.out.println("");
                found = true;
                foundUser = user;
                break;
            }
        }

        if (!found) {
            System.out.println("\n\n---------------------");
            System.out.println("USER    NOT     FOUND");
            System.out.println("---------------------\n\n");
            HomeMenu();
        } else {
            welcomeScreen(foundUser);
        }

    }

    public void welcomeScreen(User currUser) {
        System.out.println("\n\n---------------------");
        System.out.println("Welcome To MyBank");
        System.out.println("---------------------\n\n");
        System.out.println("1. Amount Deposit ");
        System.out.println("2. Amount Transfer");
        System.out.println("3. Last 5 Transaction");
        System.out.println("4. User Info");
        System.out.println("5. Log Out");

        System.out.print("Enter The choice: ");
        int choice = sc.nextInt();

        switch (choice) {
            case 1:
                deposit(currUser);
                welcomeScreen(currUser);
                break;
            case 2:
                transfer(currUser);
                welcomeScreen(currUser);
                break;
            case 3:
                transactions(currUser);
                welcomeScreen(currUser);
                break;
            case 4:
                userInfo(currUser);
                welcomeScreen(currUser);
                break;
            case 5:
                HomeMenu();
            default:
                System.out.println("Enter Correct choice");
                welcomeScreen(currUser);
        }
    }

    public void deposit(User currUser) {
        long amt = 0;
        System.out.println("Enter amount:");
        amt = sc.nextLong();
        currUser.addAmount(amt);
        System.out.println("Current Balance is : " + currUser.getBalance());
        currUser.addTransaction(amt, "credited");
    }

    public void transfer(User currUser) {
        sc.nextLine();
        System.out.println("Enter payee Name:");
        String username = sc.nextLine();
        boolean isFound = false;
        for (User user : users) {
            if (user.getUsername().equals(username)) {
                isFound = true;
                long amount = 0;
                System.out.println("Enter amount to transfer:");
                amount = sc.nextLong();
                if (currUser.getBalance() - amount < 0) {
                    System.out.println("Not Enough Balance");
                    welcomeScreen(currUser);
                    return;
                } else {
                    currUser.subAmount(amount);
                    user.addAmount(amount);
                    System.out.println("Funds Transfered");
                    System.out.println("Current balance is : " + currUser.getBalance());
                    currUser.addTransaction(amount, "debited");
                }
            }
        }
        if (!isFound) {
            System.out.println("User does not exists");
        }
    }

    public void transactions(User currUser) {
        for (String transaction : currUser.getTransactions()) {
            System.out.println(transaction);
        }
    }

    public void userInfo(User currUser) {
        System.out.println(currUser);
    }
}



public class Bank_V1 {
    public static void main(String[] args) {
        Bank bank = new Bank();
        bank.HomeMenu();
    }
}
