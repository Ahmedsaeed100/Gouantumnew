import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api/auth_api.dart';
import '../../../data/models/user_model_call.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  late UserModelCall currentUser;

  final _authApi = AuthApi();

  void login({required String email, required String password}) async {
    emit(LoadingLoginState());
    _authApi.login(email: email, password: password).then((value) {
      debugPrint(value.user!.email);
      checkUserExistInFirebase(uId: value.user!.uid);
    }).catchError((onError) {
      emit(ErrorLoginState(onError.toString()));
    });
  }

  void register({
    required String email,
    required String password,
    required String name,
    required num callMinuteCast,
  }) async {
    emit(LoadingRegisterState());
    _authApi
        .register(email: email, password: password, name: name)
        .then((value) {
      createUser(
        name: name,
        email: email,
        uId: value.user!.uid,
        callMinuteCast: callMinuteCast,
      );
    }).catchError((onError) {
      emit(ErrorRegisterState(onError.toString()));
    });
  }

  void checkUserExistInFirebase({required String uId}) {
    _authApi.checkUserExistInFirebase(uId: uId).then((user) {
      if (user.exists) {
        currentUser = UserModelCall.fromJsonMap(map: user.data()!, uId: uId);
        emit(SuccessLoginState(uId));
      } else {
        emit(ErrorLoginState('Account not exist'));
      }
    }).catchError((onError) {
      emit(ErrorLoginState(onError.toString()));
    });
  }

  void getUserData({required String uId}) {
    if (uId.isNotEmpty) {
      emit(LoadingGetUserDataState());
      _authApi.getUserData(uId: uId).then((value) {
        if (value.exists) {
          currentUser =
              UserModelCall.fromJsonMap(map: value.data()!, uId: value.id);
        } else {
          emit(ErrorGetUserDataState('User not found'));
        }
        emit(SuccessGetUserDataState());
      }).catchError((onError) {
        emit(ErrorGetUserDataState(onError.toString()));
      });
    }
  }

  void createUser(
      {required String name,
      required String email,
      required String uId,
      required num callMinuteCast}) {
    UserModelCall user = UserModelCall.resister(
      name: name,
      id: uId,
      email: email,
      avatar: 'https://i.pravatar.cc/300',
      busy: false,
      callMinuteCast: callMinuteCast,
    );
    _authApi.createUser(user: user).then((value) {
      currentUser = user;
      emit(SuccessRegisterState(uId));
    }).catchError((onError) {
      emit(ErrorRegisterState(onError.toString()));
    });
  }
}
