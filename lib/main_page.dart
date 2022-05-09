import 'package:ether_wallet/providers/main_page_provider.dart';
import 'package:ether_wallet/ui/common/full_screen_circular_progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainPageProvider _provider;
  late FToast fToast;


  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainPageProvider>(
      create: (context) => MainPageProvider(),
      child: Consumer<MainPageProvider>(
        builder: (context, provider, child) {
          _provider = provider;
          return FullScreenCircularProgressIndicator(
            loadingStatus: provider.loadingStatus,
            child: Scaffold(
              body: _container(),
            ),
          );
        },
      ),
    );
  }

  Widget _container() {
    return Container(
      child: Column(
        children: [
          clientVersion(),
          myWalletInfo(),
          Expanded(child: targetWalletInfo()),
          buttonWidget(),
        ],
      )
    );
  }

  Widget clientVersion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(top: 8.0, right: 8.0),
          child: Text(_provider.clientVersion, style: TextStyle(
            fontSize: 12.0,
            color: Color(0xFFCCCCCC),
          )),
        ),
      ],
    );
  }

  Widget myWalletInfo() {
    String myAddress = _provider.myAddress != null ?
        _provider.myAddress.hex : '';
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 160.0,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFCCCCCC),
            width: 1.0,
          )
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("My Wallet", style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color(0xFF666666),
          )),
          SizedBox(height: 8),
          Text(myAddress, style: TextStyle(
            fontSize: 11.0,
            color: Color(0xFFCCCCCC),
          )),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Balance: ",
                style: TextStyle(
                  color: Color(0xFF999999),
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 24.0,),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 120.0,
                ),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(
                            text: (_provider.balance.getInWei.toDouble() / BigInt.from(10).pow(18).toDouble()).toStringAsFixed(2),
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: " ETH",
                            style: TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 13.0,
                            ),
                          ),
                        ]
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      )
    );
  }

  Widget targetWalletInfo() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Target Address", style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFCCCCCC),
            fontSize: 14.0
          )),
          SizedBox(height: 4.0),
          _targetAddressTextField(),
          SizedBox(height: 4.0),
          _sendAmountTextField(),
        ],
      )
    );
  }

  Widget _targetAddressTextField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: Color(0xFFCCCCCC),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: _provider.targetAddressController,
        maxLines: 1,
        decoration: InputDecoration(
          hintText: "Enter the address",
          hintStyle: TextStyle(
            color: Color(0xFFCCCCCC),
            fontWeight: FontWeight.bold,
            fontSize: 13.0,
          ),
          border: InputBorder.none,
        ),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF666666),
          fontWeight: FontWeight.w200,
          fontSize: 11.0,
        ),
      ),
    );
  }

  Widget _sendAmountTextField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: Color(0xFFCCCCCC),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: _provider.sendAmountController,
        maxLines: 1,
        decoration: InputDecoration(
          hintText: "Enter the amount of ETH",
          hintStyle: TextStyle(
            color: Color(0xFFCCCCCC),
            fontWeight: FontWeight.bold,
            fontSize: 13.0,
          ),
          border: InputBorder.none,
        ),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF666666),
          fontWeight: FontWeight.w200,
          fontSize: 11.0,
        ),
      ),
    );
  }

  Widget buttonWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () async {
          bool result = await _provider.sendTransaction();
          if(result) {
            fToast.showToast(child: toastWidget("Send ETH successfully"));
          }
        },
        child: Container(
          width: 200,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.indigo,
          ),
          alignment: Alignment.center,
          child: Text("Send", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ))
        ),
      ),
    );
  }

  Widget toastWidget(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: Colors.deepPurpleAccent,
      ),
      alignment: Alignment.center,
      child: Text(text, style: TextStyle(
        color: Colors.white,
      ),
      )
    );
  }
}
