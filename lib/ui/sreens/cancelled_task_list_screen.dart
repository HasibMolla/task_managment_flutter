import 'package:flutter/material.dart';
import 'package:task_managment_flutter/data/models/task_list_by_status_model.dart';
import 'package:task_managment_flutter/data/services/network_caller.dart';
import 'package:task_managment_flutter/data/utils/urls.dart';
import 'package:task_managment_flutter/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_managment_flutter/ui/widgets/snack_bar_message.dart';


import '../widgets/screen_background.dart';
import '../widgets/task_item_widget.dart';
import '../widgets/tm_app_bar.dart';

class CancelledTaskListScreen extends StatefulWidget {
  const CancelledTaskListScreen({super.key});

  @override
  State<CancelledTaskListScreen> createState() => _CancelledTaskListScreenState();
}

class _CancelledTaskListScreenState extends State<CancelledTaskListScreen> {
  bool _getCancelledTaskListInProgress = false;
  TaskListByStatusModel? cancelledTaskListModel;

  @override
  void initState() {
    super.initState();
    _getCancelledTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: RefreshIndicator(
          onRefresh: _getCancelledTaskList,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Visibility(
                  visible: _getCancelledTaskListInProgress == false,
                  replacement: const CenteredCircularProgressIndicator(),
                  child: _buildTaskListView()),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskListView() {
    if (cancelledTaskListModel?.taskList?.isEmpty ?? true) {
      return const Center(
        child: Text(
          'No cancelled tasks available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: cancelledTaskListModel?.taskList?.length ?? 0,
      itemBuilder: (context, index) {
        return TaskItemWidget(
          taskModel: cancelledTaskListModel!.taskList![index],
          onDelete: _getCancelledTaskList,
          onStatusChanged: _getCancelledTaskList,
        );
      },
    );
  }


  Future <void> _getCancelledTaskList() async {
    _getCancelledTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(url: Urls.taskListByStatusUrl('Cancelled'));
    if (response.isSuccess) {
      cancelledTaskListModel = TaskListByStatusModel.fromJson(response.responseData!);
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _getCancelledTaskListInProgress = false;
    setState(() {});
  }
}
