import 'package:flutter/material.dart';
import 'package:task_managment_flutter/data/models/task_count_by_status_model.dart';
import 'package:task_managment_flutter/data/models/task_count_model.dart';
import 'package:task_managment_flutter/data/models/task_list_by_status_model.dart';
import 'package:task_managment_flutter/data/services/network_caller.dart';
import 'package:task_managment_flutter/data/utils/urls.dart';
import 'package:task_managment_flutter/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_managment_flutter/ui/widgets/snack_bar_message.dart';

import '../widgets/screen_background.dart';
import '../widgets/task_item_widget.dart';
import '../widgets/task_status_summary_counter_widget.dart';
import '../widgets/tm_app_bar.dart';
import 'add_new_task_screen.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {

  bool _getTaskCountByStatusInProgress = false;
  bool _getNewTaskListInProgress = false;
  TaskCountByStatusModel? taskCountByStatusModel;
  TaskListByStatusModel? newTaskListModel;

  @override
  void initState() {
    super.initState();
    _getTaskCountByStatus();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: RefreshIndicator(
          onRefresh: _getTaskCountByStatus,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildTasksSummaryByStatus(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Visibility(
                    visible: _getNewTaskListInProgress == false,
                      replacement: const CenteredCircularProgressIndicator(),
                      child: _buildTaskListView()),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          final result = await Navigator.pushNamed(context, AddNewTaskScreen.name,);
          if (result != null && result == true) {
            _getTaskCountByStatus();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskListView() {
    if (newTaskListModel?.taskList?.isEmpty ?? true) {
      return SizedBox(
        height: MediaQuery.of(context).size.height / 2, // Adjust height for AppBar and other elements
        child: const Center(
          child: Text(
            'No New tasks available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: newTaskListModel?.taskList?.length ?? 0,
      itemBuilder: (context, index) {

          return TaskItemWidget(
            taskModel: newTaskListModel!.taskList![index],
            onDelete: _getTaskCountByStatus,
            onStatusChanged: _getTaskCountByStatus,
          );
      },
    );
  }

  Widget _buildTasksSummaryByStatus() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Visibility(
        visible: _getTaskCountByStatusInProgress == false,
        replacement: const CenteredCircularProgressIndicator(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: taskCountByStatusModel?.taskByStatusList?.length ?? 0,
                itemBuilder: (context, index) {
                final TaskCountModel model = taskCountByStatusModel!.taskByStatusList![index];
                    return TaskStatusSummaryCounterWidget(
                      count: model.sum.toString(),
                      title: model.sId ?? '',
                    );
                }
            ),
          ),
        ),
      ),
    );
  }

  Future <void> _getNewTaskList() async {
    _getNewTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(url: Urls.taskListByStatusUrl('New'));
    if (response.isSuccess) {
      newTaskListModel = TaskListByStatusModel.fromJson(response.responseData!);
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _getNewTaskListInProgress = false;
    setState(() {});
  }

  Future <void> _getTaskCountByStatus() async {
    _getTaskCountByStatusInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(url: Urls.taskCountByStatusUrl);
    if (response.isSuccess) {
      taskCountByStatusModel = TaskCountByStatusModel.fromJson(response.responseData!);
      // First call the TaskCount API then call NewTask API
        _getNewTaskList();

    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _getTaskCountByStatusInProgress = false;
    setState(() {});
  }
}
