import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): string {
    return 'hello from 4444';
  }

  @Get('app1')
  getApp1(): string {
    return 'app1 from 4444';
  }

  @Get('app2')
  getApp2(): string {
    return 'app2 from 4444';
  }

  @Get('page1')
  getPage1(): string {
    return 'page1 from 4444';
  }

  @Get('admin')
  getAdmin(): string {
    return 'admin from 4444';
  }

  @Get('balance')
  getBalance(): Promise<string> {
    return this.appService.getWalletBalance();
  }
}
