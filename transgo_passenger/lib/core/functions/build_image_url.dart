String buildImageUrl(String? imagePath) {
  if (imagePath == null || imagePath.trim().isEmpty) {
    return "";
  }

  final image = imagePath.trim();

  if (image.startsWith("http://") || image.startsWith("https://")) {
    return image;
  }
  const String baseUrl = "http://192.168.113.205:8000";

  final fixedImage = image.startsWith("/") ? image.substring(1) : image;

  return "$baseUrl/$fixedImage";
}