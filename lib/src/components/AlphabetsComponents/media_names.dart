/// Content ids sometimes differ from the files already stored in assets.
const Map<String, String> audioAliases = {
  'b1': 'v',
  'zhailau': 'jailau',
  'zhalau': 'jalau',
  'zhastik': 'jastik',
  'zheide': 'jeide',
  'i1od': 'iod',
  'an1shi': 'anshi',
  'zhanalik': 'janalik',
  'parizh': 'parij',
  'football': 'futbol',
  'han': 'xan',
  'hat': 'xat',
  'check': 'chek',
};

const Map<String, String> imageAliases = {
  'dombyra': 'dombyrea',
};

String audioAssetFor(String id) {
  if (id.isEmpty) return '';
  final name = audioAliases[id] ?? id;
  return 'audio/$name.wav';
}

List<String> imageCandidates(String id) {
  if (id.isEmpty) return const [];
  final alias = imageAliases[id];
  if (alias == null || alias == id) return [id];
  return [id, alias];
}
