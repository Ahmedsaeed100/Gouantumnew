import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/home/home_cubit.dart';
import '../cubit/home/home_state.dart';
import '../views/home_views/home_screen_pageview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          var homeCubit = HomeCubit.get(context);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (state is LoadingGetUsersState ||
                        state is LoadingGetCallHistoryState)
                    ? const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 2.0),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.grey,
                        ),
                      )
                    : Container(),
                const SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: HomeScreenPageView(
                    users: homeCubit.users,
                    calls: homeCubit.calls,
                    isUsers: true,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
