List<int> customColorHexs = [
  0x1A5FC896,
  0x1A428BF9,
  0x1A42C2F9,
  0x1AFF90CC,
  0x1ADC90FF,
  0x1AFFBF90
];

int customColor(int index) {
  return customColorHexs[index % customColorHexs.length];
}
