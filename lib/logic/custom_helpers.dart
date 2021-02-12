class CustomHelpers {
  static int getDifferenceInYears(DateTime firstDate, DateTime secondDate) {
    if (firstDate.isAfter(secondDate)) {
      final temp = firstDate;
      firstDate = secondDate;
      secondDate = temp;
    }

    if (firstDate.month < secondDate.month) {
      return secondDate.year - firstDate.year;
    } else if (firstDate.month == secondDate.month &&
        firstDate.day <= secondDate.day) {
      return secondDate.year - firstDate.year;
    }
    return secondDate.year - firstDate.year - 1;
  }
}
