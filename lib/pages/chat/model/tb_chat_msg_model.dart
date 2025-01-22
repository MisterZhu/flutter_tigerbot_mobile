import 'chat_response_model.dart';

class TBChatMessageContent {
  List<TBChatMessageModel>? messages;
  TBChatMetadataModel? metadata;

  TBChatMessageContent({this.messages, this.metadata});

  TBChatMessageContent.fromJson(Map<String, dynamic> json) {
    if (json['messages'] != null) {
      messages = <TBChatMessageModel>[];
      json['messages'].forEach((v) {
        messages!.add(new TBChatMessageModel.fromJson(v));
      });
    }
    metadata = json['metadata'] != null
        ? new TBChatMetadataModel.fromJson(json['metadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    return data;
  }
}

class TBChatMetadataModel {
  StreamMetadata? streamMetadata;
  OperationMetadata? operationMetadata;

  TBChatMetadataModel({this.streamMetadata, this.operationMetadata});

  TBChatMetadataModel.fromJson(Map<String, dynamic> json) {
    streamMetadata = json['streamMetadata'] != null
        ? new StreamMetadata.fromJson(json['streamMetadata'])
        : null;
    operationMetadata = json['operationMetadata'] != null
        ? new OperationMetadata.fromJson(json['operationMetadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.streamMetadata != null) {
      data['streamMetadata'] = this.streamMetadata!.toJson();
    }
    if (this.operationMetadata != null) {
      data['operationMetadata'] = this.operationMetadata!.toJson();
    }
    return data;
  }
}

class StreamMetadata {
  bool? completed;

  StreamMetadata({this.completed});

  StreamMetadata.fromJson(Map<String, dynamic> json) {
    completed = json['completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['completed'] = this.completed;
    return data;
  }
}

class OperationMetadata {
  int? progressPercent;
  String? stage;

  OperationMetadata({this.progressPercent, this.stage});

  OperationMetadata.fromJson(Map<String, dynamic> json) {
    progressPercent = json['progressPercent'];
    stage = json['stage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['progressPercent'] = this.progressPercent;
    data['stage'] = this.stage;
    return data;
  }
}

class TBChatMessageModel {
  Citation? citation;

  Content? content;
  String? createTime;
  String? id;
  String? levelType;
  Metadata? metadata;
  String? name;
  String? parentMessageId;
  String? primaryMessageId;
  String? session;
  List<String>? siblingMessageIds;
  String? type;
  List<String>? variantMessageIds;

  TBChatMessageModel(
      {this.content,
      this.createTime,
      this.id,
      this.levelType,
      this.metadata,
      this.name,
      this.parentMessageId,
      this.primaryMessageId,
      this.session,
      this.siblingMessageIds,
      this.type,
      this.variantMessageIds});

  TBChatMessageModel.fromJson(Map<String, dynamic> json) {
    citation = json['citation'] != null
        ? new Citation.fromJson(json['citation'])
        : null;

    content =
        json['content'] != null ? new Content.fromJson(json['content']) : null;
    createTime = json['createTime'];
    id = json['id'];
    levelType = json['levelType'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
    name = json['name'];
    parentMessageId = json['parentMessageId'];
    primaryMessageId = json['primaryMessageId'];
    session = json['session'];
    if (json['siblingMessageIds'] != null) {
      siblingMessageIds = json['siblingMessageIds'].cast<String>();
    }

    type = json['type'];
    if (json['variantMessageIds'] != null) {
      variantMessageIds = json['variantMessageIds'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.citation != null) {
      data['citation'] = this.citation!.toJson();
    }
    if (this.content != null) {
      data['content'] = this.content!.toJson();
    }
    data['createTime'] = this.createTime;
    data['id'] = this.id;
    data['levelType'] = this.levelType;
    // if (this.metadata != null) {
    //   data['metadata'] = this.metadata!.toJson();
    // }
    data['name'] = this.name;
    data['parentMessageId'] = this.parentMessageId;
    data['primaryMessageId'] = this.primaryMessageId;
    data['session'] = this.session;
    // if (this.siblingMessageIds != null) {
    //   data['siblingMessageIds'] = this.siblingMessageIds!.map((v) => v.toJson()).toList();
    // }
    data['type'] = this.type;
    // if (this.variantMessageIds != null) {
    //   data['variantMessageIds'] = this.variantMessageIds!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Citation {
  List<ChatResponseItemModel>? citations;

  Citation({this.citations});

  Citation.fromJson(Map<String, dynamic> json) {
    if (json['citations'] != null) {
      citations = <ChatResponseItemModel>[];
      json['citations'].forEach((v) {
        citations!.add(new ChatResponseItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.citations != null) {
      data['citations'] = this.citations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class Citations {
//   String? description;
//   String? site;
//   String? title;
//   String? uri;
//   String? publicationDatetime;
//
//   Citations({this.description, this.site, this.title, this.uri, this.publicationDatetime});
//
//   Citations.fromJson(Map<String, dynamic> json) {
//     description = json['description'];
//     site = json['site'];
//     title = json['title'];
//     uri = json['uri'];
//     publicationDatetime = json['publicationDatetime'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['description'] = this.description;
//     data['site'] = this.site;
//     data['title'] = this.title;
//     data['uri'] = this.uri;
//     data['publicationDatetime'] = this.publicationDatetime;
//     return data;
//   }
// }
class Content {
  String? contentType;
  String? inlineSource;
  OssSource? ossSource;

  Content({this.contentType, this.inlineSource, this.ossSource});

  Content.fromJson(Map<String, dynamic> json) {
    contentType = json['contentType'];
    inlineSource = json['inlineSource'];
    ossSource = json['ossSource'] != null
        ? new OssSource.fromJson(json['ossSource'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contentType'] = this.contentType;
    data['inlineSource'] = this.inlineSource;
    if (this.ossSource != null) {
      data['ossSource'] = this.ossSource!.toJson();
    }
    return data;
  }
}

class Metadata {
  String? objectContentLength;
  String? objectContentType;
  String? objectFileSize;
  String? objectFilename;
  String? objectSource;

  Metadata(
      {this.objectContentLength,
      this.objectContentType,
      this.objectFileSize,
      this.objectFilename,
      this.objectSource});

  Metadata.fromJson(Map<String, dynamic> json) {
    objectContentLength = json['objectContentLength'];
    objectContentType = json['objectContentType'];
    objectFileSize = json['objectFileSize'];
    objectFilename = json['objectFilename'];
    objectSource = json['objectSource'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['objectContentLength'] = this.objectContentLength;
    data['objectContentType'] = this.objectContentType;
    data['objectFileSize'] = this.objectFileSize;
    data['objectFilename'] = this.objectFilename;
    data['objectSource'] = this.objectSource;
    return data;
  }
}

class OssSource {
  List<String>? inputUris;

  OssSource({this.inputUris});

  OssSource.fromJson(Map<String, dynamic> json) {
    inputUris = json['inputUris'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inputUris'] = this.inputUris;
    return data;
  }
}
