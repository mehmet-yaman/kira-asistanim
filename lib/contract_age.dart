/// Completed contract years, ignoring the time of day.
int completedContractYears(DateTime start, DateTime today) {
  final years = today.year - start.year;
  final anniversary = DateTime(today.year, start.month, start.day);
  return anniversary.isAfter(DateTime(today.year, today.month, today.day))
      ? years - 1
      : years;
}
