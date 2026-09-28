enum BudgetCategory {
  food('Food', '🍔', 'catering.restaurant'),
  shopping('Shopping', '🛍️', 'commercial.shopping_mall'),
  travel('Travel', '✈️', 'travel'),
  accommodation('Accommodation', '🏨', 'accommodation'),
  transportation('Transportation', '🚗', 'transportation'),
  entertainment('Entertainment', '🎭', 'entertainment'),
  other('Other', '📋', 'other');

  final String displayName;
  final String emoji;
  final String firebaseKey;

  const BudgetCategory(this.displayName, this.emoji, this.firebaseKey);
}
