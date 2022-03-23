abstract class RegisterStates{}

class RegisterInitialState extends RegisterStates{}

class RegisterChangeIconState extends RegisterStates{}

/////////////// USER Register //////////////////////////
class UserRegisterLoadingState extends RegisterStates{}
class UserRegisterSuccessState extends RegisterStates{}
class UserRegisterErrorState extends RegisterStates{}

////////////// CREATE USER //////////////////////////
class CreateUserLoadingState extends RegisterStates{}
class CreateUserSuccessState extends RegisterStates{}
class CreateUserErrorState extends RegisterStates{}
