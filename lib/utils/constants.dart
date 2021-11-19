class Constants {
  static const _apiKey = 'AIzaSyCaMYxQW8IqYykjlCzi21Wm88VpKsIPJ_k';

  static const authSignupUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_apiKey';

  static const authLoginUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_apiKey';

  static const userFavoritesUrl =
      'https://shop-cod3r-10e54-default-rtdb.firebaseio.com/userFavorites';

  static const productBaseUrl =
      'https://shop-cod3r-10e54-default-rtdb.firebaseio.com/products';

  static const orderBaseUrl =
      'https://shop-cod3r-10e54-default-rtdb.firebaseio.com/orders';
}
