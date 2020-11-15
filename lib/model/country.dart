class Country {
  final int id;
  final String flag;
  final String countryName;
  final String countryCode;

  Country(this.id, this.flag, this.countryName, this.countryCode);

  static List<Country> countryList() {
    return <Country>[
      Country(1, '🇮🇳', "India", "in"),
      Country(2, '🇺🇸', "United States", "us"),
      Country(3, '🇬🇧', "United Kingdom", "gb"),
      Country(5, '🇨🇭', "Switzerland", "ch"),
      Country(6, '🇨🇦', "Canada", "ca"),
      Country(7, '🇩🇪', "Germany", "de"),
      Country(9, '🇦🇺', "Australia", "au"),
      Country(10, '🇫🇷', "France", "fr"),
      Country(13, '🇿🇦', "South Africa", "za"),
    ];
  }
}
