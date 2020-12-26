String timeAgo(String dateString, {bool numericDates = true}) {

  DateTime date = DateTime.parse(dateString);
  final now = DateTime.now();
  final difference = now.difference(date);

  if ((difference.inDays / 365).floor() >= 2) {
    return 'Hace ${(difference.inDays / 365).floor()} años';
  } else if ((difference.inDays / 365).floor() >= 1) {
    return (numericDates) ? 'Hace 1 año' : 'Último año';
  } else if ((difference.inDays / 30).floor() >= 2) {
    return 'Hace ${(difference.inDays / 365).floor()} meses';
  } else if ((difference.inDays / 30).floor() >= 1) {
    return (numericDates) ? 'Hace 1 mes' : 'Último mes';
  } else if ((difference.inDays / 7).floor() >= 2) {
    return ' Hace ${(difference.inDays / 7).floor()} semanas';
  } else if ((difference.inDays / 7).floor() >= 1) {
    return (numericDates) ? 'Hace 1 semana' : 'Última semana';
  } else if (difference.inDays >= 2) {
    return 'Hace ${difference.inDays} días';
  } else if (difference.inDays >= 1) {
    return (numericDates) ? 'Hace 1 día' : 'Ayer';
  } else if (difference.inHours >= 2) {
    return 'Hace ${difference.inHours} horas';
  } else if (difference.inHours >= 1) {
    return 'Hace 1 hora';
  } else if (difference.inMinutes >= 2) {
    return 'Hace ${difference.inMinutes} minutos';
  } else if (difference.inMinutes >= 1) {
    return 'Hace 1 minuto';
  } else if (difference.inSeconds >= 3) {
    return 'Hace ${difference.inSeconds} segundos';
  } else {
    return 'Ahora';
  }
}