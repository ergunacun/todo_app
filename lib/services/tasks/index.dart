import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:todo_app_maxi_digital/errorHandling/app_exception.dart';
import 'package:todo_app_maxi_digital/services/server.dart';
import '../../models/index.dart';

class TaskService extends Server {
  TaskService({super.baseUrl = 'jsonplaceholder.typicode.com'});

  Future<List<Task>> getTasks(BuildContext context) async {
    try {
      var response = await get('/todos');
      if (response.statusCode == 200) {
        final List<dynamic> tasksData = jsonDecode(response.body);
        return tasksData.map((taskData) => Task.fromJson(taskData)).toList();
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(buildSnackBar('Unauthorized: ${response.reasonPhrase}'));
        throw AppException('Unauthorized: ${response.reasonPhrase}');
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(buildSnackBar('API endpoint not found'));
        throw AppException('API endpoint not found');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(buildSnackBar('Failed to load tasks from API'));
        throw AppException('Failed to load tasks from API');
      }
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(buildSnackBar('No internet connection'));
      throw AppException('No Internet Connection');
    } on TimeoutException {
      ScaffoldMessenger.of(context).showSnackBar(buildSnackBar('Request timed out'));
      throw AppException('Request timed out');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(buildSnackBar('An unknown error occurred'));
      throw AppException('An unknown error occurred');
    }
  }
    SnackBar buildSnackBar(String message) {
    return SnackBar(content: Text(message));
  }
}
