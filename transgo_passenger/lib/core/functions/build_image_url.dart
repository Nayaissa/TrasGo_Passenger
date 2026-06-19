String buildImageUrl(String? imagePath) {
  if (imagePath == null || imagePath.trim().isEmpty) {
    return "";
  }

  final image = imagePath.trim();

  if (image.startsWith("http://") || image.startsWith("https://")) {
    return image;
  }
  const String baseUrl = "https://alkhader.softup.agency";

  final fixedImage = image.startsWith("/") ? image.substring(1) : image;

  return "$baseUrl/$fixedImage";
}
