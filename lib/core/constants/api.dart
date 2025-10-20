class ApiConstants {
  // --- CHỌN 1 TRONG 3 DÒNG SAU, TÙY VÀO MÔI TRƯỜNG CỦA BẠN ---

  // 1. Dùng cho Android Emulator
  static const String baseUrl = "http://10.0.2.2:8081/api";

  // 2. Dùng cho iOS Simulator (iOS có thể truy cập localhost trực tiếp)
  // static const String baseUrl = "http://localhost:

  //Bạn **không thể** sử dụng `http://localhost:8081` trực tiếp từ ứng dụng di động (kể cả trên máy ảo) vì "localhost" trên máy ảo chính là bản thân máy ảo, không phải máy tính của bạn.

  //**Bạn cần thay `localhost` bằng địa chỉ IP của máy tính:**

  //*   **Nếu dùng Android Emulator:** Sử dụng địa chỉ IP đặc biệt `10.0.2.2`. URL của bạn sẽ là8081/api";

  // 3. Dùng cho thiết bị thật (thay 192.168.x.x bằng địa chỉ IP của máy tính bạn)
  // static const String baseUrl = "http://192.168.0.101:8081/api";

  // --- Endpoints ---
  static const String register = "/auth/register";
  static const String login = "/auth/login";
  static const String googleLogin = "/auth/google";
  static const String logout = "/auth/logout";
  static const String refresh = "/auth/refresh";
// Thêm các endpoints khác ở đây
}