

class FlatsModel
{
  String state;
  List data;
  FlatsModel({this.state,this.data});
  
  
  
  FlatsModel.fromJSON(Map<String, dynamic> jsn):
  state = jsn['state'],
  data = jsn['data'];


   Map<String, dynamic> toJson() =>
    {
      'state': state,
      'data': data,
    };

}