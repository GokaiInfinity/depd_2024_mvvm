part of "pages.dart";


class CostPage extends StatefulWidget {
  const CostPage({super.key});

  @override
  State<CostPage> createState() => _CostPageState();
}



class _CostPageState extends State<CostPage> {
  CostViewModel costViewModel = CostViewModel();

  @override
  void initState() {
    costViewModel.getProvinceListOrigin();
    costViewModel.getProvinceListDestination();
    super.initState();
  }

  bool _areAllFieldsFilled() {
  return selectedKurir != null &&
         selectedProvinceOrigin != null &&
         selectedCityOrigin != null &&
         selectedProvinceDestination != null &&
         selectedCityDestination != null &&
         ctrlBerat.text.isNotEmpty;
  }

  // dynamic selectedDataProvince;
  dynamic selectedProvinceOrigin;
  dynamic selectedCityOrigin;
  dynamic selectedProvinceDestination;
  dynamic selectedCityDestination;
  
  dynamic selectedKurir;

  dynamic berat;
  
  final ctrlBerat = TextEditingController();

  final List<String> kurirOptions = ['jne', 'pos', 'tiki'];

  bool isLoading = false;


  static Container loadingBlock(){
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      //black with 54% transparency
      color: Colors.black54,
        child: const SpinKitFadingCircle(size: 50,
        color: Colors.green
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Hitung Ongkir',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
          ),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider<CostViewModel>(
        create: (context) => costViewModel,
        child: Stack(
          children: [
            Container(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  children: [
                    Flexible(
                        flex: 1,
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
            
                                // Dropdown kode kurir: jne, pos, tiki dan berat
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start, 
                                        children: [
                                          const Text(
                                            "Kode Kurir",
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          const SizedBox(height: 8), // Add spacing between the label and the dropdown
                                          DropdownButton<String>(
                                          isExpanded: false, 
                                          value: selectedKurir,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          iconSize: 30,
                                          elevation: 2,
                                          hint: const Text('Pilih Kurir'), 
                                          style: const TextStyle(color: Colors.black),
                                          items: kurirOptions.map<DropdownMenuItem<String>>((String kurir) {
                                            return DropdownMenuItem<String>(
                                              value: kurir,
                                              child: Text(kurir.toUpperCase()), // Display options in uppercase
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedKurir = newValue; // Update the selected courier
                                            });
                                          },
                                        ),
                                        ],
                                      ),
                                    ),
                                    // Field Text Berat(kg)
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 16.0),
                                        child: TextFormField(
                                          controller: ctrlBerat,
                                          onChanged: (value) {
                                            setState(() {
                                              berat = value;
                                            });
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: const  InputDecoration(
                                            labelText: "Berat (kg)",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ),
            
                                  ],
                                ),
                              
                                //Origin
                                const Text("Origin",
                                    style: TextStyle(
                                      fontSize: 16,   
                                )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                
                                    //Province Origin Dropdown
                                    Flexible(
                                      flex: 1,
                                      child: Consumer<CostViewModel>(
                                        builder: (context, value, _) {
                                          switch (value.provinceListOrigin.status) {
                                            case Status.loading:
                                              return const Align(
                                                  alignment: Alignment.center,
                                                  child: CircularProgressIndicator());
                                            case Status.error:
                                              return Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                    value.provinceListOrigin.message.toString()),
                                              );
                                            case Status.completed:
                                              return DropdownButton(
                                                  isExpanded: true,
                                                  value: selectedProvinceOrigin,
                                                  icon: const Icon(Icons.arrow_drop_down),
                                                  iconSize: 30,
                                                  elevation: 2,
                                                  hint:  const Text('Pilih provinsi'),
                                                  style: const TextStyle(color: Colors.black),
                                                  items: value.provinceListOrigin.data!
                                                      .map<DropdownMenuItem<Province>>(
                                                          (Province value) {
                                                    return DropdownMenuItem(
                                                      value: value,
                                                      child:
                                                          Text(value.province.toString()),
                                                    );
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      // selectedDataProvince = newValue;
                                                      selectedProvinceOrigin = newValue;
                                                      selectedCityOrigin = null;
                                                      costViewModel.getCityListOrigin(selectedProvinceOrigin.provinceId);
                                                    });
                                                  });
                                            default:
            
                                          }
                                          return Container();
                                        },
                                      ),
                                    ),
                                
                                    const SizedBox(width: 8,),
                                
                                    // City Origin Dropdown
                                    Flexible(
                                      flex: 1,
                                      child: Consumer<CostViewModel>(
                                
                                        builder: (context, value, _) {
                                          switch (value.cityListOrigin.status) {
                                            case Status.loading:
                                              return const Align(
                                                  alignment: Alignment.center,
                                                  child: Text("Pilih provinsi dulu")
                                              );
                                            case Status.error:
                                              return Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                    value.cityListOrigin.message.toString()),
                                              );
                                            case Status.completed:
                                              return DropdownButton(
                                                  isExpanded: true,
                                                  value: selectedCityOrigin,
                                                  icon: const Icon(Icons.arrow_drop_down),
                                                  iconSize: 30,
                                                  elevation: 2,
                                                  hint:  const Text('Pilih Kota'),
                                                  style: const TextStyle(color: Colors.black),
                                                  items: value.cityListOrigin.data!
                                                      .map<DropdownMenuItem<City>>(
                                                          (City value) {
                                                    return DropdownMenuItem(
                                                      value: value,
                                                      child:
                                                          Text(value.cityName.toString()),
                                                    );
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      // selectedDataProvince = newValue;
                                                      selectedCityOrigin = newValue;
                                                      // homeViewmodel.getCityList(selectedProvince.provinceId);
                                                    });
                                                  });
                                            default:
                                          }
                                          return Container();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
            
                                
                                //Destination
                                const Text("Destination",
                                    style: TextStyle(
                                      fontSize: 16,   
                                )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                
                                    //Province Destination Dropdown
                                    Flexible(
                                      flex: 1,
                                      child: Consumer<CostViewModel>(
                                
                                        builder: (context, value, _) {
                                          switch (value.provinceListDestination.status) {
                                            case Status.loading:
                                              return const Align(
                                                  alignment: Alignment.center,
                                                  child: CircularProgressIndicator());
                                            case Status.error:
                                              return Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                    value.provinceListDestination.message.toString()),
                                              );
                                            case Status.completed:
                                              return DropdownButton(
                                                  isExpanded: true,
                                                  value: selectedProvinceDestination,
                                                  icon: Icon(Icons.arrow_drop_down),
                                                  iconSize: 30,
                                                  elevation: 2,
                                                  hint:  Text('Pilih provinsi'),
                                                  style: TextStyle(color: Colors.black),
                                                  items: value.provinceListDestination.data!
                                                      .map<DropdownMenuItem<Province>>(
                                                          (Province value) {
                                                    return DropdownMenuItem(
                                                      value: value,
                                                      child:
                                                          Text(value.province.toString()),
                                                    );
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      // selectedDataProvince = newValue;
                                                      selectedProvinceDestination = newValue;
                                                      selectedCityDestination = null;
                                                      costViewModel.getCityListDestination(selectedProvinceDestination.provinceId);
                                                    });
                                                  });
                                            default:
                                          }
                                          return Container();
                                        },
                                      ),
                                    ),
                                
                                    SizedBox(width: 8,),
                                
                                    // City Destination Dropdown
                                    Flexible(
                                      flex: 1,
                                      child: Consumer<CostViewModel>(
                                
                                        builder: (context, value, _) {
                                          switch (value.cityListDestination.status) {
                                            case Status.loading:
                                              return const Align(
                                                  alignment: Alignment.center,
                                                  child: Text("Pilih provinsi dulu")
                                              );
                                            case Status.error:
                                              return Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                    value.cityListDestination.message.toString()),
                                              );
                                            case Status.completed:
                                              return DropdownButton(
                                                  isExpanded: true,
                                                  value: selectedCityDestination,
                                                  icon: Icon(Icons.arrow_drop_down),
                                                  iconSize: 30,
                                                  elevation: 2,
                                                  hint:  Text('Pilih Kota'),
                                                  style: TextStyle(color: Colors.black),
                                                  items: value.cityListDestination.data!
                                                      .map<DropdownMenuItem<City>>(
                                                          (City value) {
                                                    return DropdownMenuItem(
                                                      value: value,
                                                      child:
                                                          Text(value.cityName.toString()),
                                                    );
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      // selectedDataProvince = newValue;
                                                      selectedCityDestination = newValue;
                                                      // homeViewmodel.getCityList(selectedProvince.provinceId);
                                                    });
                                                  });
                                            default:
                                          }
                                          return Container();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
            
                                const SizedBox(height: 16),
            
                                //Floating button
                                Center(
                                  child: FloatingActionButton.extended(
                                  onPressed: _areAllFieldsFilled() 
                                    ? () {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        costViewModel.calculateShippingCost(
                                          origin: selectedCityOrigin.cityId, 
                                          destination: selectedCityDestination.cityId, 
                                          weight: int.parse(berat), 
                                          courier: selectedKurir
                                        ).then((_) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          
                                          Fluttertoast.showToast(
                                            msg: "Estimasi harga berhasil dihitung",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.blue,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                          );
                                        }).catchError((error) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          
                                          Fluttertoast.showToast(
                                            msg: "Gagal menghitung estimasi harga",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                          );
                                        });
                                      }
                                    : null,
                                  label: const Text('Hitung Estimasi Harga',
                                      style: TextStyle(color: Colors.white)),
                                  icon: const Icon(Icons.calculate,
                                      color: Colors.white),
                                  backgroundColor: _areAllFieldsFilled() 
                                    ? Colors.blue 
                                    : Colors.grey,
                                )
                                ),

            
                                const SizedBox(height: 16),

                                // ListView

                                
                                 costViewModel.shippingCostResult.data != null
                                    ? Expanded( // Wrap with Expanded or use Flexible
                                      child: ListView.builder(
                                        shrinkWrap: true, // Add this
                                        itemCount: costViewModel.shippingCostResult.data.length,
                                        itemBuilder: (context, index) {
                                          final costs = costViewModel.shippingCostResult.data[index];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 16.0),
                                            child: Hasilongkir(costs),
                                          );
                                        },
                                      ),
                                    )
                                    : const Center(
                                        child: Text('No data available'),
                                      ),
            
            
                                // Card(
                                //   shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(12.0),
                                //   ),
                                //   color: Colors.white,
                                //   shadowColor: Colors.grey,
                                //   elevation: 4,
                                //   child: const Padding(
                                //     padding: EdgeInsets.all(16.0),
                                //     child: Row(
                                //       mainAxisAlignment: MainAxisAlignment.start,
                                //       children: [
                                //         CircleAvatar(
                                //           radius: 24,
                                //           backgroundColor: Colors.blue,
                                //           child: Icon(
                                //             Icons.monetization_on,
                                //             color: Colors.white,
                                //           )),
                                //         SizedBox(width: 32),
                                //         Column(
                                //           crossAxisAlignment: CrossAxisAlignment.start,
                                //           children: [
                                //             Text(
                                //               'Ongkos Kirim Ekonomis (OKE)', 
                                //               style: TextStyle(
                                //                 fontSize: 16,
                                //                 fontWeight: FontWeight.bold,
                                //               ),
                                //             ),
                                //             SizedBox(height: 8),
                                //             Text(
                                //               'Biaya: ' + 'Rp. 1.000.000',
                                //               style: TextStyle(
                                //                 color: Colors.grey,
                                //                 fontSize: 12,
                                //               ),
                                //             ),
                                //             SizedBox(height: 8),
                                //             Text(
                                //               'Estimasi sampai: ' + '1 Hari',
                                //               style: TextStyle(
                                //                 color: Colors.green,
                                //                 fontSize: 12,
                                //                 fontWeight: FontWeight.bold,
                                //               ),
                                //             ),
                                //           ],
                                //               ),
                                          
                                //       ],
                                //     )
                                //   )
                              
                                // ),
                                
                              ],
            
                            ),
                          ),
                        )
                      ),
                  ],
                )
                ),
                isLoading == true ?loadingBlock() : Container(),
          ],
        ),
      ),
    );
  }

}
