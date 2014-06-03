library streetlib;

import 'package:libld/libld.dart';
import 'dart:html';

part 'src/filter.dart';
part 'src/deco.dart';

class Street {
  Map source;
  Element canvas = querySelector('#street-canvas');
  Element cameraElement;
  Street(Asset streetAsset) {

    
    if (jsonExtensions.contains('street') == false)    
      jsonExtensions.add('street');    
      streetAsset.load().then((_) => _init(streetAsset.get()));
  }
  _init(Map street) {
    
    this.source = street; // for external access
    // temp vars
    String gtop = street['gradient']['top'];
    String gbottom = street['gradient']['bottom'];
    
    canvas.children.retainWhere((Element e) => e.id == 'camera');
    canvas.id = street['label'];
    
    // Set up 
    canvas.style
      ..position = 'absolute'
      ..top = '0'
      ..left = '0'
      ..width = (street['dynamic']['r'] + street['dynamic']['l'].abs()).toString() + 'px' // set width
      ..height = (street['dynamic']['b'] + street['dynamic']['t'].abs()).toString() + 'px' // set width
      ..background = '-webkit-linear-gradient(#$gtop, #$gbottom)'
      ..background = 'linear-gradient(#$gtop, #$gbottom)'
      ..perspectiveOriginY = '100%'
      ..perspective = '50';    
    
    // Populate our deco layers
    for (String layerName in street['dynamic']['layers'].keys) {
      DivElement layerElement = canvas.append(new DivElement());
      layerElement.id = layerName;
      
      Map layer = street['dynamic']['layers'][layerName];
      
      applyFilters(layerElement, layer);      
      
      // SIZE AND SCALE
      layerElement.style
        ..position = 'absolute'
        ..width = layer['w'].toString() + 'px'
        ..height = layer['h'].toString() + 'px'
        ..zIndex = (layer['z']).toString()
        ..transform = 'translateZ(' + layer['z'].toString() + 'px)'
        ..top = '0'
        ..left = '0';        
      
      
      for (Map deco in layer['decos'])
        decoManager.spawn(deco, layer, layerElement, street['dynamic']['ground_y']);
    
      // Release the reference so it can be garabage collected.
      layerElement = null;
    }   
  }
  
  camera(int x, int y) {    
    canvas.style.perspectiveOriginX = x.toString() + 'px';
    canvas.style.left = x.toString() + 'px';
    
    canvas.style.perspectiveOriginY = y.toString() + 'px';
    canvas.style.top = y.toString() + 'px';
  }  
}













