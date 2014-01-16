//
//  ViewController.m
//  PlayMusicEx01
//
//  Created by SDT-1 on 2014. 1. 16..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@end

@implementation ViewController {
	AVAudioPlayer *_player;
	NSArray *_musicFiles;
	NSTimer *_timer;
}

- (void)updateProgress:(NSTimer *)timer {
	self.progress.progress = _player.currentTime / _player.duration;
}

- (void)playMusic:(NSURL *)url {
	if(nil != _player) {
		if([_player isPlaying]) {
			[_player stop];
		}
		_player = nil;
		
		[_timer invalidate];
		_timer = nil;
	}
	
	__autoreleasing NSError *error;
	_player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	_player.delegate = self;
	
	if([_player prepareToPlay]) {
		_status.text = [NSString stringWithFormat:@"%@", [[url path] lastPathComponent]];
		[_player play];
		_timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
	}
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	self.status.text = @"재생완료";
	[_timer invalidate];
	_timer = nil;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
	_status.text = [NSString stringWithFormat:@"재생 중 오류 : %@", [error description]];
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_musicFiles count];
	
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID"];
	cell.textLabel.text = [_musicFiles objectAtIndex:indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *fileName = [_musicFiles objectAtIndex:indexPath.row];
	NSURL *urlForPlay = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
	[self playMusic:urlForPlay];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	_musicFiles = @[@"music01.mp3",@"music02.mp3",@"music03.mp3"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
