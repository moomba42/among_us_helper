/// Used to enumerate different sections in the predictions list
enum PredictionsSection { SUS, INNOCENT, UNKNOWN, DEAD }

extension GetPredictionsSectionName on PredictionsSection {
  String getName() {
    return this.toString().split(".")[1];
  }

  String getNameLowercase() {
    return this.getName().toLowerCase();
  }

  String getCamelName() {
    String name = this.getNameLowercase();
    String camelName = name.substring(0, 1).toUpperCase() + name.substring(1);
    return camelName;
  }
}

// TODO: Use after https://github.com/dart-lang/language/issues/65
// typedef Predictions = Map<PredictionsSection, List<Player>>;
