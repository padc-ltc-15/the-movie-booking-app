import 'package:dio/dio.dart';
import 'package:moviebooking/data/model/vos/city_vo.dart';
import 'package:moviebooking/data/model/vos/user_data_vo.dart';
import 'package:moviebooking/network/api_constants.dart';
import 'package:moviebooking/network/response/data_response.dart';
import 'package:retrofit/http.dart';

part 'movie_booking_api.g.dart';

@RestApi(baseUrl: BASE_URL_DIO)
abstract class MovieBookingApi {
  factory MovieBookingApi(Dio dio) = _MovieBookingApi;

  @FormUrlEncoded()
  @POST(ENDPOINT_GET_OTP)
  Future<DataEmptyResponse> getOTP(
    @Field("phone") String phone,
  );

  @FormUrlEncoded()
  @POST(ENDPOINT_SIGN_IN_WITH_PHONE)
  Future<DataResponse<UserDataVo>> signInWithPhone(
    @Field("phone") String phone,
    @Field("otp") String otpCode,
  );

  @GET(ENDPOINT_GET_CITIES)
  Future<DataResponse<List<CityVo>>> getCities();

}
