// class TBAssistantsModel {
//   List<Assistants>? assistants;
//
//   TBAssistantsModel({this.assistants});
//
//   TBAssistantsModel.fromJson(Map<String, dynamic> json) {
//     if (json['assistants'] != null) {
//       assistants = <Assistants>[];
//       json['assistants'].forEach((v) {
//         assistants!.add(new Assistants.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.assistants != null) {
//       data['assistants'] = this.assistants!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class TBAssistantsModel {
  String? createTime;
  String? description;
  String? displayName;
  String? name;
  String? updateTime;

  TBAssistantsModel(
      {this.createTime,
      this.description,
      this.displayName,
      this.name,
      this.updateTime});

  TBAssistantsModel.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    description = json['description'];
    displayName = json['displayName'];
    name = json['name'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['description'] = this.description;
    data['displayName'] = this.displayName;
    data['name'] = this.name;
    data['updateTime'] = this.updateTime;
    return data;
  }
}

class TBSessionData {
  final String groupName;
  final List<TBSessionModel> sessions;

  TBSessionData({required this.groupName, required this.sessions});
}

class TBSessionModel {
  String? assistant;
  String? availability;
  String? createTime;
  String? description;
  String? displayName;
  String? id;
  Metadata? metadata;
  String? name;
  String? owner;
  PluginConfig? pluginConfig;
  String? updateTime;
  bool? isSelect;

  TBSessionModel(
      {this.assistant,
      this.availability,
      this.createTime,
      this.description,
      this.displayName,
      this.id,
      this.metadata,
      this.name,
      this.owner,
      this.pluginConfig,
      this.updateTime,
      this.isSelect});

  TBSessionModel.fromJson(Map<String, dynamic> json) {
    assistant = json['assistant'];
    availability = json['availability'];
    createTime = json['createTime'];
    description = json['description'];
    displayName = json['displayName'];
    id = json['id'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
    name = json['name'];
    owner = json['owner'];
    pluginConfig = json['pluginConfig'] != null
        ? new PluginConfig.fromJson(json['pluginConfig'])
        : null;
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assistant'] = this.assistant;
    data['availability'] = this.availability;
    data['createTime'] = this.createTime;
    data['description'] = this.description;
    data['displayName'] = this.displayName;
    data['id'] = this.id;
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    data['name'] = this.name;
    data['owner'] = this.owner;
    if (this.pluginConfig != null) {
      data['pluginConfig'] = this.pluginConfig!.toJson();
    }
    data['updateTime'] = this.updateTime;
    return data;
  }
}

class Metadata {
  String? model;

  Metadata({this.model});

  Metadata.fromJson(Map<String, dynamic> json) {
    model = json['model'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model'] = this.model;
    return data;
  }
}

class PluginConfig {
  DocumentAnalysis? documentAnalysis;
  DocumentAnalysis? onlineSearch;
  DocumentAnalysis? imageGeneration;

  PluginConfig({this.documentAnalysis, this.onlineSearch});

  PluginConfig.fromJson(Map<String, dynamic> json) {
    documentAnalysis = json['documentAnalysis'] != null
        ? new DocumentAnalysis.fromJson(json['documentAnalysis'])
        : null;
    onlineSearch = json['onlineSearch'] != null
        ? new DocumentAnalysis.fromJson(json['onlineSearch'])
        : null;
    imageGeneration = json['imageGeneration'] != null
        ? new DocumentAnalysis.fromJson(json['imageGeneration'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.documentAnalysis != null) {
      data['documentAnalysis'] = this.documentAnalysis!.toJson();
    }
    if (this.onlineSearch != null) {
      data['onlineSearch'] = this.onlineSearch!.toJson();
    }
    if (this.imageGeneration != null) {
      data['imageGeneration'] = this.imageGeneration!.toJson();
    }
    return data;
  }
}

class DocumentAnalysis {
  bool? enabled;

  DocumentAnalysis({this.enabled});

  DocumentAnalysis.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['enabled'] = this.enabled;
    return data;
  }
}
