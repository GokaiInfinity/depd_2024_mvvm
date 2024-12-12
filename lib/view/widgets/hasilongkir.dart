part of 'widgets.dart';

class Hasilongkir extends StatelessWidget { // Change to StatelessWidget
  final Costs costs;
  const Hasilongkir(this.costs, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Colors.white,
      shadowColor: Colors.grey,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue,
              child: const Icon(
                Icons.monetization_on,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 32),
            Expanded( // Wrap column with Expanded
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Add this
                children: [
                  Text(
                    '${costs.description ?? 'N/A'} (${costs.service ?? 'N/A'})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Biaya: Rp. ${costs.cost?.isNotEmpty == true ? costs.cost![0].value ?? 'N/A' : 'N/A'}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Estimasi sampai: ${costs.cost?.isNotEmpty == true ? costs.cost![0].etd ?? 'N/A' : 'N/A'}',  
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}