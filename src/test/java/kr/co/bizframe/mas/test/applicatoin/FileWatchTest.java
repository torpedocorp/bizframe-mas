package kr.co.bizframe.mas.test.applicatoin;

import java.nio.file.Paths;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardWatchEventKinds;

import java.nio.file.WatchEvent;
import java.nio.file.WatchKey;
import java.nio.file.WatchService;
import java.util.List;

public class FileWatchTest {

	public void test() {

		System.out.println("start");
		Path myDir = Paths.get("D:/data");

		try {
			WatchService watcher = myDir.getFileSystem().newWatchService();
			myDir.register(watcher, StandardWatchEventKinds.ENTRY_CREATE,
					StandardWatchEventKinds.ENTRY_DELETE,
					StandardWatchEventKinds.ENTRY_MODIFY);

			WatchKey watckKey = watcher.take();

			List<WatchEvent<?>> events = watckKey.pollEvents();
			for (WatchEvent event : events) {
				if (event.kind() == StandardWatchEventKinds.ENTRY_CREATE) {
					System.out.println("Created: " + event.context().toString());
					System.out.println("Created: " + ((Path)event.context()).toAbsolutePath());
				}
				if (event.kind() == StandardWatchEventKinds.ENTRY_DELETE) {
					System.out.println("Delete: " + event.context().toString());
					System.out.println("Delete: " + event.count());
					System.out.println("Delete: " + ((Path)event.context()).toAbsolutePath());

				}
				if (event.kind() == StandardWatchEventKinds.ENTRY_MODIFY) {
					System.out.println("Modify: " + event.context().toString());
					System.out.println("Modify: " + event.count());
					System.out.println("Modify: " + ((Path)event.context()).toAbsolutePath());

				}
			}
			watckKey.reset();
		} catch (Exception e) {
			System.out.println("Error: " + e.toString());
		}
	}

	public static void main(String[] argv) {
		FileWatchTest ft = new FileWatchTest();
		while(true){
			ft.test();
		}
	}
}
