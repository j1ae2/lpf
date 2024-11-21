import 'package:animated_icon/animated_icon.dart';
import 'package:elimapass/services/tarjeta_service.dart';
import 'package:flutter/material.dart';
import 'package:peerdart/peerdart.dart';

import 'app_home.dart';

class TarjetaPage extends StatefulWidget {
  const TarjetaPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TarjetaPageState();
  }
}

class _TarjetaPageState extends State<TarjetaPage> {
  TarjetaService tarjetaService = TarjetaService();
  Peer peer = Peer(options: PeerOptions(debug: LogLevel.All));
  late DataConnection conn;
  bool connected = false;
  PagoStatus status = PagoStatus.PENDING;
  bool loading = false;

  @override
  void dispose() {
    peer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 700), connect);
    peer.on<DataConnection>("connection").listen((event) {
      conn = event;

      conn.on("close").listen((event) {
        setState(() {
          connected = false;
        });
      });

      setState(() {
        connected = true;
      });
    });
  }

  void sendTarjeta() async {
    setState(() {
      loading = true;
    });
    String? id = await tarjetaService.provider.getTarjeta();

    if (id == null) return;
    conn.send(id);
  }

  void connect() {
    final connection = peer.connect("ac8a4d66-3d0d-4e96-8d68-b407537d31b7");
    conn = connection;

    conn.on("open").listen((event) {
      setState(() {
        connected = true;
      });
      sendTarjeta();

      connection.on("close").listen((event) {
        setState(() {
          connected = false;
        });
      });

      conn.on("data").listen((data) {
        if (data < 0) {
          setState(() {
            status = PagoStatus.FALLIDO;
          });
        } else {
          setState(() {
            status = PagoStatus.EXITOSO;
          });
        }
        setState(() {
          loading = false;
        });
        Future.delayed(
            const Duration(
              milliseconds: 2500,
            ), () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (ctx) => const AppHome(),
              ),
              (Route<dynamic> route) => false);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left_outlined,
            size: 35,
          ),
          color: Colors.white,
        ),
        backgroundColor: const Color(0XFF405f90),
        title: const Text(
          "Pagar viaje",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  status == PagoStatus.PENDING
                      ? "Acerca tu celular para realizar el pago"
                      : status == PagoStatus.EXITOSO
                          ? "¡Pago exitoso!"
                          : "!Saldo insuficiente!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              loading
                  ? const Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    )
                  : Transform.scale(
                      scale: 2,
                      child: AnimateIcon(
                        key: UniqueKey(),
                        iconType: IconType.continueAnimation,
                        animateIcon: status == PagoStatus.EXITOSO
                            ? AnimateIcons.checkmarkOk
                            : status == PagoStatus.FALLIDO
                                ? AnimateIcons.cross
                                : AnimateIcons.wifiSearch,
                        onTap: () {},
                        height: 100,
                        width: 100,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
              Hero(
                tag: 'tarjeta',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: const Image(
                    image: AssetImage('assets/lima_pass.jpg'),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

enum PagoStatus { EXITOSO, FALLIDO, PENDING }
