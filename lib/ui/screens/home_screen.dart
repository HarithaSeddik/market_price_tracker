import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_tracker_challenge/domain/cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:price_tracker_challenge/domain/cubits/ticker_cubit/ticker_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    /// By wrapping these widgets by BlocBuilder,
    /// only the state-related UI will rerender upon state changes (button state)
    /// This is superior to setState() method and other state-management
    /// since it minimizes rendering
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      builder: (context, state) {
        return state is HomeScreenLoaded
            ? PriceTrackerBody(state)
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
      },
    );
  }
}

class PriceTrackerBody extends StatelessWidget {
  const PriceTrackerBody(this.homeScreenState, {super.key});

  final HomeScreenLoaded homeScreenState;
  @override
  Widget build(context) {
    return Center(
      child: Column(children: [
        const SizedBox(height: 150),
        //builder method for dropdown Menus
        _buildDropdownMenus(context),
        const SizedBox(height: 50),
        //User BlocConsumer for when you want to build UI tied to states, and also perform other actions based on stream of emitted states (e.g AlertDialogs)
        BlocConsumer<TickerCubit, TickerState>(
          listener: (context, state) {
            // Listen for emitted error states, and display a popup dialog (e.g Market is closed)
            if (state is TickerError) {
              _showAlertDialog(context, state);
            }
          },
          builder: (context, state) {
            debugPrint('TickerState: $state');
            return _buildTicker(state);
          },
        )
      ]),
    );
  }

  //helper method
  Color _getTickerColor(TickerLoaded state) {
    if (state is TickerPriceIncreased) {
      return const Color.fromARGB(255, 79, 182, 83);
    } else if (state is TickerPriceDecreased) {
      return const Color.fromARGB(255, 234, 64, 51);
    } else {
      return const Color.fromARGB(255, 219, 218, 218);
    }
  }

  Future<void> _showAlertDialog(BuildContext context, TickerError state) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // User can dismiss by clicking on background
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(228, 215, 215, 215),
          title:
              Text('${state.ticker.error?.code}', textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('${state.ticker.error?.message}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok', textAlign: TextAlign.center),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTicker(TickerState state) {
    if (state is TickerInitial) {
      return Container();
    }
    if (state is TickerLoading) {
      return const CircularProgressIndicator(
        color: Colors.white,
      );
    }
    if (state is TickerLoaded) {
      return Container(
        height: 60,
        width: 230,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(166, 151, 150, 150),
        ),
        child: Text(
          state.ticker.tick?.quote.toString() ?? '',
          style: TextStyle(
            color: _getTickerColor(state),
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildDropdownMenus(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(166, 151, 150, 150),
      ),
      child: Column(
        children: [
          //MarketDropdown Menu
          DropdownButton<String>(
            value: homeScreenState.marketDropDownValue,
            items: homeScreenState.activeMarketValues
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: BlocProvider.of<HomeScreenCubit>(context)
                .onMarketDropdownChanged,
            alignment: AlignmentDirectional.center,
            dropdownColor: const Color.fromARGB(173, 134, 48, 42),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 241, 238, 238),
            ),
            isExpanded: true,
            iconEnabledColor: const Color.fromARGB(227, 167, 59, 51),
            iconSize: 45,
          ),
          const SizedBox(height: 50),
          //Symbol Dropdown Menu
          DropdownButton<String>(
            value: homeScreenState.symbolDropDownValue,
            items: homeScreenState.availableSymbolValues
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              BlocProvider.of<TickerCubit>(context).unsubscribeTicker();
              final symbol = BlocProvider.of<HomeScreenCubit>(context)
                  .onSymbolsDropdownChanged(value);
              BlocProvider.of<TickerCubit>(context).subscribeTicker(symbol);
            },
            alignment: AlignmentDirectional.center,
            dropdownColor: const Color.fromARGB(173, 134, 48, 42),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 241, 238, 238),
            ),
            isExpanded: true,
            iconEnabledColor: const Color.fromARGB(227, 167, 59, 51),
            iconSize: 45,
          ),
        ],
      ),
    );
  }
}
