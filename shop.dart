import 'dart:io';

void main() {
  clearConsole();

  List products = [
    ['🥚 Eggs', 2000, 25],
    ['🥛 Milk', 10000, 2],
    ['🥧 Cereal', 25000, 3],
    ['🧃 Yogurt', 15000, 7],
    ['🫙  Pasta Sauce', 19000, 10],
    ['🍞 Wheat Bread', 5000, 6],
    ['🍕 Frozen Pizza', 30000, 5],
    ['🥔 Potato Chips', 25000, 15],
    ['💧 Bottled Water', 5000, 10],
    ['☕️ Ground Coffee', 10000, 5],
  ];

  String? userChoice = '';
  List userCart = [];

  // receiving user choice
  while (true) {
    while (true) {
      printOptions();

      userChoice = stdin.readLineSync();
      if (userChoice == '1' || userChoice == '2' || userChoice == '3') {
        break;
      }
    }
    // switch case for user choice
    switch (userChoice) {
      case '1':
        userCart = seeProducts(products, userCart);
        break;
      case '2':
        seeCart(userCart);
        break;
      case '3':
        exitApp();
        break;
      default:
        print('Error in switch funtion');
    }
  }
}

/* <----------------------------------------- CASES -----------------------------------------> */
// case 1
dynamic seeProducts(List productsName, List userCart) {
  clearConsole();

  String userChoiseBuy = '';
  // ignore: unused_local_variable
  String productAmount = '';

  // List userCart = [];
  List userChoicesList = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

  // loop breaks when user enters stop
  while (!(userChoiseBuy.toLowerCase() == 'menu')) {
    // receiving what product user would like to buy
    productsPrinter(productsName);
    while (true) {
      userChoiseBuy = stdin.readLineSync()!;
      // directing to menu if user enters 'menu'
      if (userChoiseBuy.toLowerCase() == 'menu') {
        return userCart;
      } else if (userChoicesList.contains(userChoiseBuy)) {
        break;
      }
      stdout.write('\nPlease, enter a valid option: ');
      productsPrinter(productsName);
    }
    clearConsole();

    while (true) {
      // receiving amount of product user would like to buy
      stdout.write(
          'How many ${productsName[int.parse(userChoiseBuy) - 1][0]} would you like to buy: ');
      String? productAmount = stdin.readLineSync();

      // checking if the user entered number
      if (isNumber(productAmount!)) {
        // checking whether the quantity requested by the user is in stock or not
        if (int.parse(productAmount) <=
            productsName[int.parse(userChoiseBuy) - 1][2]) {
          // calling function
          userCart = reduceAddProduct_informUser(
              productsName, userChoiseBuy, productAmount, userCart);
          break;
          // checking if the user wants product even though there is no desired amount left
        } else {
          clearConsole();
          print(
              '''Sorry, we do not have $productAmount amount of ${productsName[int.parse(userChoiseBuy) - 1][0]}!
We only have ${productsName[int.parse(userChoiseBuy) - 1][2]} ☹️''');
          // asking new product amount from user
          while (true) {
            stdout.write('How many would you like to buy: ');
            String? newProductAmount = stdin.readLineSync();
            // checking if the user entered number and correct amount of product
            if (isNumber(newProductAmount!) &&
                productsName[int.parse(userChoiseBuy) - 1][2] >=
                    int.parse(newProductAmount)) {
              // calling function
              userCart = reduceAddProduct_informUser(
                  productsName, userChoiseBuy, newProductAmount, userCart);
              break;
              // warning user
            } else {
              clearConsole();
              print('Please, enter a valid option ⚠️');
            }
          }
          break;
        }
      } else {
        print('Please, enter a valid option ⚠️');
      }
      clearConsole();
    }
  }
}

// case 2
void seeCart(List userCart) {
  // promocodes with their expiring date
  List promocodesForPurchase = [
    [
      'NEWCUSTOMER',
      [2024, 05, 05],
      5000
    ],
    [
      'GRANDOPENING',
      [2024, 01, 01],
      10000
    ],
    [
      '2024',
      [2024, 12, 01],
      2024
    ],
  ];

  clearConsole();
  int userCartSum = 0;
  int discountAmount = 0;
  String? promocodeYesNo = '';

  // checking if the user added something in the cart
  if (userCart.length == 0) {
    stdout.write(
        'You have nothing in your cart! Please, add something and come back later :]\n');
    pressEnter();
    return;
  }

  // printing what user added to cart
  for (var product in userCart) {
    print('${product[0]}: ${product[1]} x ${product[2]}');
    userCartSum = (product[1] * product[2]) + userCartSum;
  }
  print('\n🛒 Your purchase: $userCartSum');

  // asking whether user likes to continue shopping or not
  while (true) {
    stdout.write(
        '\nPress enter to continue or type \'finish\' to finish your shopping: ');
    String? enter_or_finish = stdin.readLineSync();
    if (enter_or_finish == '') {
      return;
    } else if (enter_or_finish == 'finish') {
      break;
    }
  }

  clearConsole();
  print('Your cart🛒: $userCartSum uzs');

  // asking whether user have a promocode
  while (true) {
    stdout.write('Do you have promocode (Y/N): ');
    promocodeYesNo = stdin.readLineSync();
    if (promocodeYesNo!.toUpperCase() == 'Y' ||
        promocodeYesNo.toUpperCase() == 'N') {
      break;
    }
    clearConsole();
    print('Please, enter a valid option ⚠️');
  }

  // giving discount for user's purchase
  if (promocodeYesNo.toUpperCase() == 'Y') {
    bool isPromocodeFound = false;
    bool isPromocodeValid = false;

    clearConsole();

    // receiving user promocode
    stdout.write('Please, enter your promocode: ');
    String? userInput_promocode = stdin.readLineSync();

    // checking if there is a promo code
    for (var promos in promocodesForPurchase) {
      if (promos[0] == userInput_promocode!.toUpperCase()) {
        isPromocodeFound = true;
        // getting current date
        var currentDate = (DateTime.now().toString()).split(' ');

        List<String> dateParts = currentDate[0].split('-');
        List validTime = promos[1];

        // checking whether promoce is valid
        if ((int.parse(dateParts[0]) <= validTime[0])) {
          if (int.parse(dateParts[1]) < validTime[1]) {
            discountAmount = promos[2];
            isPromocodeValid = true;
          } else if (int.parse(dateParts[2]) <= validTime[2]) {
            isPromocodeValid = true;
            discountAmount = promos[2];
          } else {
            print('Promocode you entered has been expired!');
          }
        }
      }
    }

    // user entered invalid promocode
    if (!isPromocodeFound) {
      print('We could\'nt find promocode named $userInput_promocode');
      pressEnter();
    }

    // user entered valid promocode
    if (isPromocodeValid) {
      clearConsole();
      int userCartSum_box = userCartSum;
      // subtract the amount of the promo code discount from the userCartSum
      userCartSum -= discountAmount;
      print('\n ___________________________________________________________\n'
          '|                                                           |\n'
          '| Promocode successfully has been added to your purchase!🎉 |\n'
          '|___________________________________________________________|\n');

      print('Your purchase: ');

      // printing user cart one last time
      for (var product in userCart) {
        print('${product[0]}: ${product[1]} x ${product[2]}');
      }
      print('\n🛒 Sum: $userCartSum_box ❌ $userCartSum ✅\n');
    }
  }

  // asking user's card type
  while (true) {
    stdout.write('💳 Uzcard or Humo: ');
    String cardType = stdin.readLineSync()!;
    if (cardType.toLowerCase() == 'uzcard' ||
        cardType.toLowerCase() == 'humo') {
      break;
    }
  }
  clearConsole();

  // asking user pin code
  stdout.write('Please enter you pin code: ');
  // ignore: unused_local_variable
  String? userCardPinCode = stdin.readLineSync();

  clearConsole();

  print('$userCartSum was successfully withdrawn from the card 🎉\n'
      'Thank you for visiting us today! Come back anytime. Have a fantastic day!!!');
  pressEnter();
}

// case 3
void exitApp() {
  print('Thank you for using our App!😉');
  exit(0);
}

/* <--------------------------------------- FUNCTIONS ---------------------------------------> */

void clearConsole() {
  stdout.write('\x1B[2J\x1B[0;0H');
}

void printOptions() {
  clearConsole();
  stdout.write('''🍎 1. To see products
🛒 2. To see cart
❌ 3. To exit app
Choose one: ''');
}

// function to check if the coming string number
bool isNumber(String splitChar) {
  try {
    // ignore: unused_local_variable
    int numInt = int.parse(splitChar);
    return true;
  } catch (e) {
    return false;
  }
}

void productsPrinter(productName) {
  clearConsole();
  print(' _____________________________\n'
      '|                             |\n'
      '| Type \'menu\' to open menu Ⓜ️  |\n'
      '|_____________________________|\n');
  int i = 1;
  print('Product name -> Price');
  for (var each in productName) {
    print("$i. ${each[0]} -> ${each[1]} uzs");
    i++;
  }

  stdout.write('Which one would you like to buy: ');
}

void pressEnter() {
  stdout.write('Press enter to continue ');
  // ignore: unused_local_variable
  String? pressedEnter = stdin.readLineSync();
}

List reduceAddProduct_informUser(List productsName, String userChoiceBuy,
    String productAmount, List userCart) {
  // reduce the product amount by the amount taken by the user
  productsName[int.parse(userChoiceBuy) - 1][2] -= int.parse(productAmount);

  // informing user that adding product to cart was successful
  clearConsole();
  print(
      '${productsName[int.parse(userChoiceBuy) - 1][0]} successfully has been added to your cart🛒!');

  // adding product to user cart
  userCart.add([
    productsName[int.parse(userChoiceBuy) - 1][0],
    int.parse(productAmount),
    productsName[int.parse(userChoiceBuy) - 1][1]
  ]);
  pressEnter();
  return userCart;
}
