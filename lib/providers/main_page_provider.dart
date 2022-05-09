import 'package:ether_wallet/utils/loading_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:math';

// CHAIN_ID	Chain(s)
// 1	Ethereum mainnet
// 2	Morden (disused), Expanse mainnet
// 3	Ropsten
// 4	Rinkeby
// 5	Goerli
// 42	Kovan
// 1337	Geth private chains (default)

// account1 : 0xf4c125985ED0683A2a03D44Fc6cc03BDe6fE2F91
// account2 : 0x063B4E20350373882df482FBC5a8ab0a5dEf3A20

class MainPageProvider extends ChangeNotifier {
  MainPageProvider() {
    initialize();
  }

  final LoadingStatus loadingStatus = LoadingStatus();

  // final apiUrl = "http://localhost:8545"; //Replace with your API
  // final privateKey = "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80";

  // metamask rinkeby testnet account 1
  final apiUrl = "https://rinkeby.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161";
  final privateKey = "0x87a67e68ec68db9287a6337daf82e1df820460ab635eeb3587444e4d90eefcef";

  late EthereumAddress myAddress;
  late EtherAmount balance = EtherAmount.zero();

  late Web3Client ethClient;
  late EthPrivateKey credentials;

  TextEditingController targetAddressController = TextEditingController();
  TextEditingController sendAmountController = TextEditingController();

  String clientVersion = '';

  initialize() async {
    try {
      var httpClient = Client();
      ethClient = Web3Client(apiUrl, httpClient);
      credentials = EthPrivateKey.fromHex(privateKey);

      // You can now call rpc methods. This one will query the amount of Ether you own
      myAddress = credentials.address;
      balance = await ethClient.getBalance(credentials.address);

      clientVersion = await ethClient.getClientVersion();
      print("## client version: $clientVersion");
      print("## balance : ${balance.getValueInUnit(EtherUnit.ether)}");
      notifyListeners();
    } catch(e) {
      print("## error: ${e.toString()}");
    }
  }

  Future<bool> sendTransaction() async {
    loadingStatus.start();
    notifyListeners();

    int transactionCount = await ethClient.getTransactionCount(myAddress, atBlock: BlockNum.current());
    print("## sendTransaction() >> isExists credentials: ${credentials.address.hex}");
    print("## sendTransaction() >> transactionCount: ${transactionCount}");
    print('## estimated gas : ${await ethClient.getGasPrice()}');
    try {
      String result = await ethClient.sendTransaction(
        credentials,
        Transaction(
          to: EthereumAddress.fromHex(targetAddressController.text),
          from: EthereumAddress.fromHex(credentials.address.hex),
          // gasPrice: EtherAmount.inWei(BigInt.from(2200000111)),
          gasPrice: null,
          maxGas: null,

          value: EtherAmount.fromUnitAndValue(
              EtherUnit.szabo, BigInt.from(double.parse(sendAmountController.text) * pow(10, 6))),
        ),
        chainId: 4, // ropsten
        
        // chainId: 1337 // Geth private chains
      );
    
      print("## sendTransaction() result: $result");

      balance = await ethClient.getBalance(credentials.address);
      sendAmountController.text = '';
      loadingStatus.done();
      notifyListeners();
    } catch(e) {
      print("## sendTransaction() error: ${e.toString()}");
      loadingStatus.done();
      notifyListeners();
      return false;
    }
    return true;
  }
}