abstract class LoginStates{}

class LoginInitialState extends LoginStates{}

class LoginChangeIconState extends LoginStates{}

class LoginLoadingState extends LoginStates{}
class LoginSuccessState extends LoginStates{}
class LoginErrorState extends LoginStates{}

class GoogleSignInLoadingState extends LoginStates{}
class GoogleSignInErrorState extends LoginStates{}

class FacebookSignInLoadingState extends LoginStates{}
class FacebookSignInErrorState extends LoginStates{}

class CreateUserLoadingState extends LoginStates{}
class CreateUserSuccessState extends LoginStates{}
class CreateUserErrorState extends LoginStates{}