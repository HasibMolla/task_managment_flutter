import 'package:flutter/material.dart';
import 'package:task_managment_flutter/data/models/task_list_by_status_model.dart';
import 'package:task_managment_flutter/data/models/task_model.dart';
import 'package:task_managment_flutter/data/services/network_caller.dart';
import 'package:task_managment_flutter/data/utils/urls.dart';
import 'package:task_managment_flutter/ui/widgets/snack_bar_message.dart';

class TaskItemWidget extends StatefulWidget {
  const TaskItemWidget({
    super.key,
    required this.taskModel,
    this.onDelete,
    this.onStatusChanged,
  });

  final TaskModel taskModel;
  final VoidCallback? onDelete;
  final VoidCallback? onStatusChanged;

  @override
  State<TaskItemWidget> createState() => _TaskItemWidgetState();
}
class _TaskItemWidgetState extends State<TaskItemWidget> {
  bool _addNewTaskInProgress =false;
  TaskListByStatusModel? newTaskListModel;
  TaskModel? newTaskModel;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tileColor: Colors.white30,
        title: Text(
          widget.taskModel.title ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.taskModel.description ?? ''),
            Text(
              'Created Date: ${widget.taskModel.createdDate ?? ''}',
              style: const TextStyle(color: Colors.grey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: _getStatusColor(widget.taskModel.status ?? 'New'),
                  ),
                  child: Text(
                    widget.taskModel.status ?? 'New',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _showDeleteDialogue();
                      },
                      icon: const Icon(Icons.delete, color: Colors.redAccent,),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        _showEditDialog();
                      },
                      icon: const Icon(Icons.edit, color: Colors.indigo,),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Task Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatusOption('New'),
              _buildStatusOption('Progress'),
              _buildStatusOption('Completed'),
              _buildStatusOption('Cancelled'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusOption(String status) {
    return ListTile(
      title: Text(status),
      onTap: () {
        if (widget.taskModel.status != status) {
          _updateTaskStatus(status);
        }
        Navigator.pop(context); // Close the dialog box after selection
      },
    );
  }

  Future<void> _updateTaskStatus(String newStatus) async {
    Future<void> createNewTask() async{
      _addNewTaskInProgress = true;
      setState(() {});
      Map<String, dynamic> requestBody = {
        "title": widget.taskModel.title,
        "description": widget.taskModel.description,
        "status": newStatus
      };
      final NetworkResponse response = await NetworkCaller.postRequest(url: Urls.createTaskUrl, body: requestBody);
      _addNewTaskInProgress = false;
      setState(() {});
      if (response.isSuccess) {

      }
      else {
        showSnackBarMessage(context, response.errorMessage);
      }
    }
    createNewTask();
    _deleteTask();
  }

  void _showDeleteDialogue() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirm Delete?'),
            actions: [
              GestureDetector(
                onTap: () {
                  _deleteTask();
                  Navigator.pop(context);
                  showSnackBarMessage(context, 'Task Deleted Successfully');
                },
                child: const Text('Confirm'),
              ),
              const SizedBox(height: 5,),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              )
            ],
          );
        });
  }

  Future<void> _deleteTask() async {
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.deleteTaskUrl(widget.taskModel.sId ?? ''),
    );

    if (response.isSuccess) {
      // Call onDelete if provided
      widget.onDelete?.call();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.errorMessage)),
      );
    }
  }

  Color _getStatusColor(String taskStatus) {
    if (taskStatus == 'New') {
      return Colors.blueAccent;
    } else if (taskStatus == 'Progress') {
      return Colors.pink;
    } else if (taskStatus == 'Cancelled') {
      return Colors.redAccent;
    } else {
      return Colors.green;
    }
  }
}